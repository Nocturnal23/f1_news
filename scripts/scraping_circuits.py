import requests
from bs4 import BeautifulSoup
import json
import re
import os

FILE_JSON_CIRCUITI = "f1_news_circuits_extra_data.json"

# Mappatura: "tua_chiave_json" -> "Slug_Nazione_Sito_F1"
# NOTA: Controlla sul sito F1 come scrivono esattamente le nazioni nell'URL per il 2026
MAPPATURA_CIRCUITI = {
    "albert_park": "australia",
    "shanghai": "china",
    "suzuka": "japan",
    "miami": "miami",
    "villeneuve": "canada",
    "monaco": "monaco",
    "catalunya": "barcelona-catalunya",
    "red_bull_ring": "austria",
    "silverstone": "great-britain",
    "spa": "belgium",
    "hungaroring": "hungary",
    "zandvoort": "netherlands",
    "monza": "Italy",
    "madring": "spain",
    "baku": "azerbaijan",
    "marina_bay": "singapore",
    "americas": "united-states",
    "rodriguez": "mexico",
    "interlagos": "brazil",
    "vegas": "las-vegas",
    "losail": "qatar",
    "yas_marina": "united-arab-emirates"
}

def trova_valore_regex(soup, espressione):
    """Trova il valore testuale ignorando maiuscole e minuscole"""
    elemento = soup.find(string=re.compile(espressione, re.IGNORECASE))
    if elemento:
        # Spesso sui circuiti il dato è nel div o p successivo
        return elemento.find_next().text.strip()
    return None

def aggiorna_json_circuiti():
    dati_esistenti = {}
    
    # 1. RECUPERO DATI ESISTENTI
    if os.path.exists(FILE_JSON_CIRCUITI):
        print(f"File {FILE_JSON_CIRCUITI} trovato. Recupero i dati in memoria...")
        try:
            with open(FILE_JSON_CIRCUITI, "r", encoding="utf-8") as file:
                dati_esistenti = json.load(file)
        except json.JSONDecodeError:
            print("  -> ATTENZIONE: Il file esistente ha un errore di formattazione. Parto da zero.")

    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

    # 2. INIZIO SCRAPING
    for circuito_key, slug_url in MAPPATURA_CIRCUITI.items():
        print(f"Scraping in corso per: {circuito_key}...")
        
        # URL per la pagina del circuito (struttura tipica del sito F1)
        url = f"https://www.formula1.com/en/racing/2026/{slug_url}.html"
        risposta = requests.get(url, headers=headers)
        
        # Recuperiamo il circuito dal JSON o creiamo un oggetto vuoto
        dati_circuito = dati_esistenti.get(circuito_key, {})
        
        if risposta.status_code != 200:
            print(f"  -> ATTENZIONE: Pagina non trovata per {circuito_key} (URL: {url}).")
            dati_esistenti[circuito_key] = dati_circuito
            continue
            
        soup = BeautifulSoup(risposta.text, 'html.parser')

        # --- ESTRAZIONE E AGGIORNAMENTO DATI ---
        
        # 1. Lunghezza Circuito (Circuit Length)
        length_testo = trova_valore_regex(soup, r"Circuit Length")
        if length_testo:
            # Rimuoviamo "km" e trasformiamo in float (es. "5.278 km" -> 5.278)
            l_pulito = length_testo.lower().replace('km', '').strip()
            try:
                dati_circuito["trackLength"] = float(l_pulito)
            except ValueError:
                pass

        # 2. Numero di Giri (Number of Laps)
        laps_testo = trova_valore_regex(soup, r"Number of Laps")
        if laps_testo and laps_testo.isdigit():
            dati_circuito["lapsNumber"] = int(laps_testo)

        # 3. Primo Gran Premio (First Grand Prix) - NUOVO CAMPO
        first_gp_testo = trova_valore_regex(soup, r"First Grand Prix")
        if first_gp_testo and first_gp_testo.isdigit():
            dati_circuito["firstGrandPrix"] = int(first_gp_testo)
        elif "firstGrandPrix" not in dati_circuito:
            # Se la pagina non lo ha e non era nel JSON, lo creiamo vuoto
            dati_circuito["firstGrandPrix"] = 0

        # 4. Giro Veloce (Fastest lap time)
        # Cerchiamo l'etichetta corretta mostrata nell'HTML
        record_label = soup.find(string=re.compile(r"Fastest lap time", re.IGNORECASE))
        
        if record_label:
            # 1° Salto: Prendiamo il tempo (il tag <dd>)
            tempo_tag = record_label.find_next()
            tempo = tempo_tag.text.strip()
            
            # 2° Salto: Prendiamo il pilota e l'anno (il tag <span> successivo)
            pilota_tag = tempo_tag.find_next()
            pilota_anno = pilota_tag.text.strip() if pilota_tag else ""
            
            # Il sito scrive "Kevin Magnussen (2024)". Noi lo formattiamo col trattino
            # Sostituiamo la parentesi aperta con " - " e togliamo la parentesi chiusa
            pilota_formattato = pilota_anno.replace(' (', ' - ').replace(')', '')
            
            # Uniamo tutto insieme e salviamo
            dati_circuito["lapRecord"] = f"{tempo} - {pilota_formattato}"
            
        elif "lapRecord" not in dati_circuito:
            dati_circuito["lapRecord"] = "TBD"

        # Aggiorniamo il contenitore principale
        dati_esistenti[circuito_key] = dati_circuito

    # 3. SALVATAGGIO
    with open(FILE_JSON_CIRCUITI, "w", encoding="utf-8") as file:
        json.dump(dati_esistenti, file, indent=2, ensure_ascii=False)
        
    print(f"\n--- Operazione completata! Il file {FILE_JSON_CIRCUITI} è stato aggiornato. ---")

if __name__ == "__main__":
    aggiorna_json_circuiti()