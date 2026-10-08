import requests
from bs4 import BeautifulSoup
import json
import re
import os

FILE_JSON_PILOTI = "f1_news_drivers_extra_data.json"

MAPPATURA_PILOTI = {
    "colapinto": "franco-colapinto",
    "gasly": "pierre-gasly",
    "alonso": "fernando-alonso",
    "stroll": "lance-stroll",
    "bortoleto": "gabriel-bortoleto",
    "hulkenberg": "nico-hulkenberg",
    "bottas": "valtteri-bottas",
    "perez": "sergio-perez",
    "hamilton": "lewis-hamilton",
    "leclerc": "charles-leclerc",
    "bearman": "oliver-bearman",
    "ocon": "esteban-ocon",
    "antonelli": "kimi-antonelli",
    "russell": "george-russell",
    "lawson": "liam-lawson",
    "arvid_lindblad": "arvid-lindblad",
    "hadjar": "isack-hadjar",
    "max_verstappen": "max-verstappen",
    "albon": "alexander-albon",
    "sainz": "carlos-sainz"
}

def estrai_risultati(testo_posizione):
    """
    Legge il formato del sito (es. '1 (x10)', '3 (x1)', '2')
    Restituisce: (numero_volte_in_quella_posizione, miglior_risultato_formattato)
    """
    if not testo_posizione or testo_posizione.upper() == "N/A":
        return 0, ""
        
    match = re.search(r'(\d+)(?:\s*\([xX](\d+)\))?', testo_posizione)
    if match:
        posizione = int(match.group(1))
        volte = int(match.group(2)) if match.group(2) else 1
        
        if posizione == 1:
            return volte, "1°"
        else:
            return 0, f"{posizione}°"
            
    return 0, ""

def trova_valore_regex(soup, espressione):
    elemento = soup.find(string=re.compile(espressione, re.IGNORECASE))
    if elemento:
        return elemento.find_next().text.strip()
    return None

def aggiorna_json_piloti():
    dati_esistenti = {}
    
    if os.path.exists(FILE_JSON_PILOTI):
        print(f"File {FILE_JSON_PILOTI} trovato. Recupero i dati in memoria...")
        try:
            with open(FILE_JSON_PILOTI, "r", encoding="utf-8") as file:
                dati_esistenti = json.load(file)
        except json.JSONDecodeError:
            print("  -> ATTENZIONE: Il file esistente ha un errore di formattazione. Parto da zero.")

    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

    for pilota_key, slug_url in MAPPATURA_PILOTI.items():
        print(f"Scraping in corso per: {pilota_key}...")
        
        url = f"https://www.formula1.com/en/drivers/{slug_url}.html"
        risposta = requests.get(url, headers=headers)
        
        dati_pilota = dati_esistenti.get(pilota_key, {})
        
        if risposta.status_code != 200:
            print(f"  -> ATTENZIONE: Pagina non trovata per {pilota_key} (URL: {url}).")
            dati_esistenti[pilota_key] = dati_pilota
            continue
            
        soup = BeautifulSoup(risposta.text, 'html.parser')
        nome_default = slug_url.replace("-", " ").title()

        # --- CAMPI BASE ---
        dati_pilota["nome"] = nome_default
        dati_pilota["dataDiNascita"] = trova_valore_regex(soup, r"Date of birth") or ""
        
        # --- PRESERVAZIONE CAMPI MANUALI ---
        # Solo 'debut' e 'teams' vengono inizializzati e protetti
        if "debut" not in dati_pilota:
            dati_pilota["debut"] = ""
        if "teams" not in dati_pilota:
            dati_pilota["teams"] = []

        # --- ESTRAZIONE DATI AGGIORNABILI ---
        
        # GP Totali
        gp_testo = trova_valore_regex(soup, r"Grands Prix Entered")
        if gp_testo:
            gp_pulito = gp_testo.replace(',', '')
            if gp_pulito.isdigit():
                dati_pilota["gpDisputed"] = int(gp_pulito)
                
        # Punti Totali (Career Points)
        points_testo = trova_valore_regex(soup, r"Career Points$")
        if points_testo:
            p_pulito = points_testo.replace(',', '')
            try:
                dati_pilota["totalPoints"] = float(p_pulito)
            except ValueError:
                pass

        # Podi
        podium_testo = trova_valore_regex(soup, r"^Podiums")
        if podium_testo and podium_testo.isdigit():
            dati_pilota["podium"] = int(podium_testo)

        # Vittorie e Miglior Piazzamento
        finish_testo = trova_valore_regex(soup, r"Highest race finish")
        if finish_testo:
            vittorie, nuovo_miglior_risultato = estrai_risultati(finish_testo)
            dati_pilota["gpWin"] = vittorie
            
            vecchio_best_result = dati_pilota.get("bestResult", "")
            if nuovo_miglior_risultato:
                if not vecchio_best_result.startswith(nuovo_miglior_risultato):
                    dati_pilota["bestResult"] = nuovo_miglior_risultato

        # Pole Position
        grid_testo = trova_valore_regex(soup, r"Highest grid position")
        if grid_testo:
            poles, _ = estrai_risultati(grid_testo)
            dati_pilota["polePosition"] = poles
            
        # Mondiali Vinti
        wdc_testo = trova_valore_regex(soup, r"World Championships")
        if wdc_testo and wdc_testo.isdigit():
            dati_pilota["wdc"] = int(wdc_testo)
        elif wdc_testo == "N/A" or not wdc_testo:
            dati_pilota["wdc"] = 0
            
        dati_esistenti[pilota_key] = dati_pilota

    # Salvataggio
    with open(FILE_JSON_PILOTI, "w", encoding="utf-8") as file:
        json.dump(dati_esistenti, file, indent=2, ensure_ascii=False)
        
    print(f"\n--- Operazione completata! Il file {FILE_JSON_PILOTI} è stato aggiornato. ---")

if __name__ == "__main__":
    aggiorna_json_piloti()