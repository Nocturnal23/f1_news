import requests
from bs4 import BeautifulSoup
import json
import re
import os

FILE_JSON = "f1_news_constructors_extra_data.json"

MAPPATURA_TEAM = {
    "alpine": "alpine",
    "aston_martin": "aston-martin",
    "audi": "audi",
    "cadillac": "cadillac",
    "ferrari": "ferrari",
    "haas": "haas",
    "mclaren": "mclaren",
    "mercedes": "mercedes",
    "rb": "racing-bulls",
    "red_bull": "red-bull-racing",
    "williams": "williams"
}

ECCEZIONI_MANUALI = {
    "williams": {
        "wdcConstructor": 9
    }
}

def estrai_risultati(testo_posizione):
    """
    Legge il formato del sito (es. '1 (x249)', '5 (x1)', '2')
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

def estrai_lista_nomi(soup, espressione):
    testo = trova_valore_regex(soup, espressione)
    if testo:
        if testo.upper() == "N/A":
            return []
        testo = testo.replace('/', ',')
        return [nome.strip() for nome in testo.split(",") if nome.strip()]
    return []

def genera_json_team():
    dati_completi = {}
    dati_esistenti = {}
    
    if os.path.exists(FILE_JSON):
        print(f"File {FILE_JSON} trovato. Recupero i dati in memoria...")
        try:
            with open(FILE_JSON, "r", encoding="utf-8") as file:
                dati_esistenti = json.load(file)
        except json.JSONDecodeError:
            print("  -> ATTENZIONE: Il file esistente contiene errori di formattazione. Parto da zero.")

    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

    for team_key, slug_url in MAPPATURA_TEAM.items():
        print(f"Scraping in corso per: {team_key}...")
        
        url = f"https://www.formula1.com/en/teams/{slug_url}.html"
        risposta = requests.get(url, headers=headers)
        
        dati_team = dati_esistenti.get(team_key, {})
        
        if risposta.status_code != 200:
            print(f"  -> ERRORE: Pagina non trovata per {team_key}. Salto il team.")
            dati_completi[team_key] = dati_team
            continue
            
        soup = BeautifulSoup(risposta.text, 'html.parser')
        
        # --- INIZIALIZZAZIONE CAMPI BASE E MANUALI ---
        dati_team["nome"] = trova_valore_regex(soup, r"Full Team Name") or dati_team.get("nome", "")
        dati_team["debut"] = trova_valore_regex(soup, r"First Team Entry") or dati_team.get("debut", "")
        dati_team["teamChief"] = estrai_lista_nomi(soup, r"Team Chief")
        dati_team["technicalChief"] = estrai_lista_nomi(soup, r"Technical Chief")
        dati_team["chassis"] = trova_valore_regex(soup, r"Chassis") or dati_team.get("chassis", "")
        dati_team["powerUnit"] = trova_valore_regex(soup, r"Power Unit") or dati_team.get("powerUnit", "")
        dati_team["reserveDriver"] = estrai_lista_nomi(soup, r"Reserve Driver")
        
        # Campi che tu compili manualmente e non devono sparire se vuoti
        if "wdcDriver" not in dati_team:
            dati_team["wdcDriver"] = 0
        if "bestResult" not in dati_team:
            dati_team["bestResult"] = ""
            
        # --- ESTRAZIONE DATI AGGIORNABILI ---
        
        # Base e Paese
        base_testo = trova_valore_regex(soup, r"Base")
        if base_testo:
            if "," in base_testo:
                parti = base_testo.split(",")
                dati_team["base"] = parti[0].strip()
                dati_team["country"] = parti[1].strip()
            else:
                dati_team["base"] = base_testo
                dati_team["country"] = dati_team.get("country", "")

        # GP Totali
        gp_testo = trova_valore_regex(soup, r"Grands Prix Entered")
        if gp_testo:
            gp_pulito = gp_testo.replace(',', '')
            if gp_pulito.isdigit():
                dati_team["gpDisputed"] = int(gp_pulito)
                
        # Punti Totali (Team Points)
        points_testo = trova_valore_regex(soup, r"^Team Points$")
        if points_testo:
            p_pulito = points_testo.replace(',', '')
            try:
                dati_team["totalPoints"] = float(p_pulito)
            except ValueError:
                pass
                
        # --- NUOVA LOGICA VITTORIE E BEST RESULT ---
        finish_testo = trova_valore_regex(soup, r"Highest Race Finish")
        if finish_testo:
            vittorie, nuovo_miglior_risultato = estrai_risultati(finish_testo)
            dati_team["gpWin"] = vittorie
            
            vecchio_best_result = dati_team.get("bestResult", "")
            if nuovo_miglior_risultato:
                if not vecchio_best_result.startswith(nuovo_miglior_risultato):
                    dati_team["bestResult"] = nuovo_miglior_risultato
            
        # Titoli Costruttori
        wdc_testo = trova_valore_regex(soup, r"World Championships")
        if wdc_testo and wdc_testo.isdigit():
            dati_team["wdcConstructor"] = int(wdc_testo)
            
        # --- APPLICAZIONE ECCEZIONI MANUALI ---
        if team_key in ECCEZIONI_MANUALI:
            for campo, valore_corretto in ECCEZIONI_MANUALI[team_key].items():
                dati_team[campo] = valore_corretto
                print(f"    -> Applicata eccezione manuale per {team_key}: {campo} = {valore_corretto}")
            
        dati_completi[team_key] = dati_team

    with open(FILE_JSON, "w", encoding="utf-8") as file:
        json.dump(dati_completi, file, indent=2, ensure_ascii=False)
        
    print(f"\n--- Operazione completata! Il file {FILE_JSON} è pronto. ---")

if __name__ == "__main__":
    genera_json_team()