# myWardrobeApp

myWardrobeApp è un'applicazione iOS nativa sviluppata per aiutare gli utenti a digitalizzare e gestire il proprio guardaroba, creare outfit e ricevere consigli di stile in modo intelligente.

## 🛠 Tecnologie Utilizzate

Il progetto è costruito utilizzando le tecnologie più moderne dell'ecosistema Apple, affiancate a servizi cloud per la gestione dei dati.

- **Swift & SwiftUI**: L'intera interfaccia utente e la logica dell'applicazione sono scritte in Swift, sfruttando le potenzialità di SwiftUI per creare viste reattive, moderne e dichiarative.
- **CoreML**: L'applicazione integra modelli di Machine Learning personalizzati (`ClothesStyleClassifier` e `ClothesTypeClassifier`) per riconoscere automaticamente la tipologia e lo stile dei capi d'abbigliamento a partire dalle foto caricate dall'utente.
- **Firebase Firestore**: Utilizzato come database cloud (NoSQL) per memorizzare e sincronizzare i dati dei capi e degli outfit, garantendo sicurezza e accessibilità in tempo reale.
- **Network Framework (Apple)**: Impiegato per il monitoraggio costante dello stato della connessione (tramite `NWPathMonitor`), permettendo all'app di gestire la connettività in modo proattivo (con banner di notifica dedicati).
- **UserDefaults**: Utilizzato per la persistenza locale e la cache dei dati, permettendo all'applicazione un caricamento rapido dei capi al momento dell'avvio, anche in caso di connettività limitata.

## ✨ Funzionalità Principali

- **Gestione Intelligente del Guardaroba**: Aggiungi, visualizza e organizza i tuoi vestiti. L'app sfrutta l'elaborazione delle immagini e algoritmi specifici (come `Sweetercolor` e `ClosestColor`) per estrarre e classificare automaticamente il colore principale dei vestiti.
- **Creazione e Gestione Outfit**: Un'interfaccia dedicata permette di combinare i capi salvati per creare, salvare e visualizzare i propri outfit preferiti.
- **Sezione Consigli (Advices)**: Una schermata apposita che offre all'utente suggerimenti e consigli, migliorando l'esperienza d'uso e la combinazione dei vestiti.
- **Riconoscimento Automatico dei Capi**: Durante l'aggiunta di un nuovo vestito, l'app utilizza i modelli ML per classificare in automatico la categoria del capo e il suo stile, riducendo l'inserimento manuale dei dati.
- **UX Resiliente alla Rete**: Gestione fluida delle disconnessioni con avvisi visivi animati all'interno della view principale, per tenere sempre informato l'utente.

## 📂 Struttura del Progetto

- `Screens/`: Contiene le viste dell'interfaccia utente (es. `OutfitScreen`, `ClothesScreen`, `AdvicesScreen`, `AddOutfitScreen`).
- `CreateML/`: Ospita i modelli di machine learning (`.mlmodel`) allenati per il riconoscimento dei capi.
- `Utility/`: Moduli di supporto per il database (`Database.swift`), classificatori (`Classifier.swift`), networking e manipolazione delle immagini (ridimensionamento, compressione).
- `Structs/` & `enum/`: Definizione dei modelli di dati principali (come `Cloth`, `Outfit`) e delle tipologie di classificazione (Categoria, Colore, Stile, Taglia).
