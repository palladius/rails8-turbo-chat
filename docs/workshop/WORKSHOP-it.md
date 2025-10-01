## Rails + MCP + Gemini Workshop v1.0.4a

<!-- Questo è il documento principale.
Usa `just translate-workshop-to-italian` per tradurlo in italiano.

CHANGELOG
01oct25 v1.0.4 [ricc] Aggiunta la versione nel titolo H1 e rimossi i TODO alla fine, riformulati come quest.
29sep25 v1.0.3 [ricc] Rinumerati i titoli a partire da 0.
28sep29 v1.0.2 [ricc] Traduzione migliorata, spostato il git clone DOPO gemini-cli
28sep25 v1.0.1 [ricc] Spostato in docs/workshop/. Aggiunta la dipendenza da GC e alcuni screenshot carini.
27sep25 v1.0.0 [ricc] ...
-->

🇬🇧 English version available [here](WORKSHOP.md) 🇬🇧

**TL;DR** In questo workshop:

1. Scaricheremo Gemini CLI
2. Scaricheremo l'app e inizieremo a fare qualche domanda a Gemini.
3. Eseguiremo l'app "vanilla", senza nessuna magia. Alcune funzionalità non saranno ancora disponibili.
4. Otterremo crediti GCP, recupereremo una 🔑 GEMINI API KEY e la inseriremo in `.env`
5. Riavvieremo l'app e testeremo la magia. Ora la chat funziona e crea immagini fantastiche!
6. Ora iniziamo a giocare con MCP e configuriamo Gemini CLI per connettersi all'MCP della tua app Rails! Ora puoi parlare con la tua app in linguaggio naturale!
7. Creeremo la tua funzione MCP e la testeremo da Gemini CLI!

**Nota**. Il workshop è costellato di 🧙‍♂️ missioni 🧙‍♂️. Se risolvi la missione in un workshop fisico, dillo ai tuoi mentori! Se sei veloce, potresti ricevere un regalo.
**Nota**. Questo workshop è stato creato per il **Devfest Modena**. Potrebbero mancarti delle informazioni se non sei un partecipante a questo workshop.

## 0. Prerequisiti

* Avere un account **GMail**. Questo è necessario per richiedere i crediti GCP e per consentire l'uso di Gemini LLM!
* `ruby` installato localmente. Raccomandiamo un gestore di versioni come `rbenv`, `rvm`, `asdf` o qualsiasi cosa funzioni per te.
* [opzionale] Un account **GitHub**. Questo è necessario solo se vuoi fare un fork del repository, per utenti avanzati.
* [opzionale] Installa [just](https://github.com/casey/just). Altrimenti, guarda le ricette in `justfile`.

### Installa/Scarica il codice

1. `git clone https://github.com/palladius/rails8-turbo-chat.git`
2. `cp .env.dist .env`: ti servirà più tardi.

Ricorda la 📂 CARTELLA in cui ti trovi, dovrai avviare `gemini` da questa esatta cartella.

------

## 1. Installa Gemini CLI (e ottieni informazioni sull'app)

<!-- **Perché**. È probabilmente più facile se gli utenti possono sfruttare Gemini CLI fin dall'inizio. Possono chiedere
1. Cosa fa l'app
2. Riguardo all'ultimo commit, e così via.
-->

Per **installare** Gemini CLI, usa uno dei seguenti comandi:

```bash
# Usando npx (nessuna installazione richiesta)
npx https://github.com/google-gemini/gemini-cli
# Installa globalmente con `npm`
npm install -g @google/gemini-cli
# Installa globalmente con Homebrew (macOS/Linux)
brew install gemini-cli
```

Altre opzioni di installazione [qui](https://github.com/google-gemini/gemini-cli).

Per **avviare** Gemini CLI:

1. Cambia directory nella cartella dell'app Rails 📂 che hai scaricato prima: `cd percorso/della/cartella/rails8-turbo-chat/`
2. Digita semplicemente: `gemini` e segui il flusso di autenticazione di Google.

Ora usiamo Gemini CLI per una gratificazione immediata:

1. **Di cosa parla l'app?**
   1. `gemini -p "Spiegami l'architettura di questa codebase. Parlami dei modelli Rails e di come interagiscono tra loro"`
2. **Quali modifiche recenti sono state apportate al repository?** Questo è un prompt potente per aggiornarsi sulle modifiche dei colleghi (o per un riepilogo di una modifica che hai fatto ieri sera!)

```bash
$ gemini
## Copia queste 4 righe e incollale in Gemini CLI!
Dammi un riassunto di tutte le modifiche di oggi/ieri, in formato markdown.
Se non ci sono modifiche negli ultimi 2 giorni, prendi invece gli ultimi 3 commit.
Dai un'occhiata a git diff e vedi quali modifiche sono state introdotte e perché. Un punto elenco per hash di commit, per favore.
Salva questo output in `out/git-summary.md`
```

![3 stili di sviluppatori diversi](image-4.png)

3. **Qual è lo stile di codifica di Riccardo o Christian?**. Puoi anche fare domande simili a quelle umane!

```bash
$ gemini
Controlla gli ultimi 3 commit di:
- Christian
- Emiliano
- Riccardo
Dai un'occhiata al codice in git diff e fornisci due informazioni per persona:
1. Che stile di codifica hanno
2. Che tipo di codice tendono a modificare (frontend, backend, GCP, Docs, ..)
Salva questo output in `out/people-style-summary.md`
```

Trova le risposte di esempio in `docs/workshop/examples/` :)

------

## 2. Gratificazione immediata

<!-- **Perché**. Questo passaggio serve a rendere l'utente felice e coinvolto con il minor sforzo possibile.
-->

In questo passaggio, installerai l'app e la eseguirai

1. `cd rubyllm_chat_app/`
2. Installa ruby e bundler
3. Esegui `bundle install`
4. Esegui `bundle exec rails db:setup`
1. [ricc] `bundle exec rails server` per eseguire il server sulla porta 8080
1. Apri il browser all'indirizzo http://localhost:8080/. Dovresti vedere una pagina come quella qui sotto:
![pagina vuota della nuova app](image.png)
1. Fai clic su "Sign up" e aggiungi:
   1. La tua **Email**, **Nome**, **Password** e ripetila in **Conferma Password**
   2. Lascia vuota la *Gemini API Key* (non è necessaria per ora).
![pagina di registrazione](image-1.png)
1. Fatto! Ora possiamo creare la tua prima chat
![registrazione riuscita](image-2.png)
1. Fai clic su "Start New Chat".
   1. oh oh - questo non funziona! Abbiamo bisogno di una Gemini API Key.

TODO(Christian): `rails s` e configurazione del DB.


**Nota**. Questo dovrebbe funzionare con tutto tranne le immagini e la chat, quindi forse dovremmo usare una sorta di generazione del DB (`rake db:seed`?) per generare una chat finta. Questo sarà un buon modo per mostrare l'app funzionante senza dover ancora configurare la chiave API: piccoli passi.

------

## 3. Ottieni la Gemini API Key e inizia a creare immagini!

### 3a. Richiedi i crediti GCP..


<!-- **Perché**. In questo passaggio l'utente farà due cose:
    1. recuperare i crediti Cloud per usare Gemini (noioso), ma anche
    2. Usare quei crediti
-->

* recupera i crediti facendo clic qui: https://trygcp.dev/e/devfest-maudna-25 accedendo con il tuo account Google *personale*.
* Segui il link per ottenere `5$` di crediti. Saranno sufficienti per il workshop.
* Vai su https://aistudio.google.com/apikey e genera una GEMINI API KEY. Annotala localmente nel tuo file `.env`, sotto `GEMINI_API_KEY`
* Se sei confuso, controlla queste [slide passo-passo](https://docs.google.com/presentation/d/1mY0BwcZERAqilVh4BaQfuX-RyayXrC4N2Pno4tzWcig/edit?) che il team ha creato per te.

### 3b. .. e usa Gemini alla grande!

Ora che hai fatto la parte noiosa, sei pronto a generare le tue prime immagini?

* Per prima cosa, controlla che Gemini funzioni all'interno dell'app. Il modo più semplice è chiamare `just test-gemini`
* riavvia l'app.
* Assicurati che la Gemini API Key funzioni
  * Forse assicurati che una chiave API mancante generi un avviso visibile in alto?
  * Se vedi l'errore, significa che hai sbagliato qualcosa. Se l'errore è scomparso, sei a posto!
![chiave API gemini mancante](missing-gemini-api-key.png)
* Crea una nuova chat.
* Fai una domanda...
  * Osserva la magia: viene generata un'immagine e anche una sinossi della chat
  * TODO ricc: screenshot prima
  * TODO ricc: screenshot dopo

### 3c modifica la generazione di immagini


🧙‍♂️ **Missione** 🧙‍♂️ Hai notato che tutte le immagini escono con un cuore giallo e un rubino? Sembra che ci sia un easter egg nel codice.

* Trova la parte del codice in cui aggiunge queste 2 "filigrane" (o "watermark") all'immagine
* Cambiala con qualcosa di locale alla tua geografia, ad esempio (per Modena, per includere il volto di Pavarotti).
* Testa la nuova generazione (possibilmente ricaricando l'app)
* Mostra a un supervisore per ottenere il tuo premio.

------

## 4. Testa l'MCP esistente

<!--
Qui mostriamo che abbiamo già un MCP pre-costruito
-->

1. Risolviamo i problemi con `npx @modelcontextprotocol/inspector`
2. Fai clic sul link dalla CLI (nota l'MCP_PROXY_AUTH_TOKEN!), qualcosa del tipo: `http://localhost:6274/?MCP_PROXY_AUTH_TOKEN=blahblahblah`
3. Configura:
   1. Tipo di trasporto: **SSE**
   2. URL: `http://localhost:8080/mcp/sse` - TODO(Christian), mi confermi usiamo 8080? o 3000?
4. Fai clic su **connect**.
5. Se funziona, fai clic su **Tools**
6. Fai clic su List Tools.
7. Dovresti vedere questo: ![Elenco degli strumenti su MCP](image1.png)
8. Fai clic su uno strumento da eseguire, ad esempio `Chat List`. Goditi un output come questo! Nota che il server MCP sta chiamando ActiveRecord qui!

![Chiamata strumento - chatlist](image2.png)


### 4.A - testa lo stesso sul tuo IDE

Se hai `vscode`, IntelliJ, Claude Code, ora puoi testare MCP. Controlla la configurazione del tuo agente su come aggiungere l'MCP.

#### Aggiungi MCP locale a Gemini CLI


* Usa `gemini mcp` per aggiungere il nostro MCP dinamicamente:
  * `gemini mcp add --transport sse local-rails8-turbo-chat-sse http://localhost:8080/mcp/sse`
  * Questo configurerà gemini per avere questo MCP disponibile.
* **Riavvia** `gemini` (doppio CTRL-C). Gli MCP vengono caricati all'avvio, quindi non dimenticarlo!
* Digita `/mcp` per assicurarti che sia stato fatto correttamente. Dovresti vedere qualcosa del genere:

![Test di /mcp ](image.png)


Se stai usando altri strumenti (vscode, copilot, Claude Code), controlla la documentazione per aggiungerli.
Di solito è necessario aggiungere un JSON come questo:

```json
{
  // ..Altre opzioni qui..
  "mcpServers": {
    // ..Altri server MCP qui..
    "rails-chat-sse-localhost": {
      "type": "sse",
      "url": "http://localhost:8080/mcp/sse"
    }
  }
}
```

Al tuo file locale (ad es. `.vscode/settings.json` per Visual Studio code).

Ora puoi interagire con Gemini CLI (o Copilot, Claude, ..) e iniziare a interagire con la tua applicazione con domande come:

*  `Recupera un elenco di chat: qualche chat che contiene cibo italiano?`
*  `Aggiungi un utente creato "test-workshop@example.com" e password "PincoPallinoJoe" e nome "Test per Workshop"`
![Richieste MCP per chiamare la creazione dell'utente](image-1.png)
![utente creato correttamente](image-3.png)
   *  `Ora elenca gli utenti` (che dovrebbe mostrare anche il nuovo utente)
![L'elenco mostra anche l'ultimo utente](image-2.png)
* Chiedi `Usa MCP per rinominare automaticamente tutte le chat`. Questo dovrebbe aggiornare magicamente i titoli delle chat per tutte le chat con nomi errati.

------

## 5. Aggiungi il tuo MCP

**Idee**. Ok, è ora di programmare qualcosa da solo! Puoi essere creativo o prendere spunto da queste idee:

* `che_ora_è`: Aggiungi una funzione "Che data/ora è".
* `dove_sono`: Chiama un'API esterna per recuperare il meteo locale o la città più vicina.
* *Magia di ActiveRecord*: Un po' di magia di ActiveRecord per contare le relazioni e fornire una statistica (quanti utenti hanno creato quante chat).
* TODO(Emiliano): qualche idea su cosa possiamo aggiungere qui?

**Esecuzione**.

Hai un'idea di cosa programmare? Fantastico!

Ora:
1. Aggiungi la tua funzione a `app/tools/`.
2. Ricorda di sottoclassare da `ActionTool::Base`. Maggiori dettagli in https://github.com/yjacquin/fast-mcp
3. Una volta che funziona, carica `rails c` e testa prima che il codice funzioni come previsto.
3. Quindi, ricarica `rails s`; questo assicura che la tua app abbia la nuova funzione!
4. Ora è il momento di testarlo con i tuoi strumenti MCP! Per prima cosa usa Gemini CLI (ricarica anche questo) tramite `/mcp` per verificare che la nuova funzionalità sia apparsa.
5. Testa la funzione ponendo una domanda in linguaggio naturale che corrisponda alla descrizione della funzione (ad es. "Che ora è / Dove sono / ...").


------


## 6. [opzionale] Salva le immagini su GCS 🧙‍♂️

OMG, sei arrivato qui più velocemente di quanto potessimo documentarlo! È ora di una sfida!

🧙‍♂️ Impara a salvare la tua immagine su Google Cloud Storage. La documentazione ufficiale di Active Storage + GCS è [qui](https://guides.rubyonrails.org/active_storage_overview.html#google-cloud-storage-service).
<!--
Questo è un punto di svolta, poiché un push sul cloud renderà persistenti le immagini su computer diversi e tra locale e remoto. Ma è difficile da configurare.
-->


## 7. [opzionale] Prova `docker compose`

🧙‍♂️  Lo sapevi che Cloud Run ora supporta docker-compose in alpha? 🧙‍♂️

Per prima cosa, prova questo localmente:

```bash
cd rubyllm_chat_app/
docker-compose up
docker compose run web todo # TODO(Emiliano) qualche comando come rake db:seed o qualche test diverso
```

Secondo, una volta che funziona, prova questo nel Cloud:

```bash
gcloud alpha run compose --help
```

🧙‍♂️ Facci sapere se ce la fai! 🧙‍♂️


<!-- TODO(Emiliano): completa questo -->


## 8. [opzionale] Crea e avvia su Cloud Run tramite `docker compose alpha`

<!-- una volta configurato GCS, e forse Emiliano può aiutare, il resto è un gioco da ragazzi, almeno per Riccardo
TODO(ricc/Emiliano)

-->                                                                              │

🧙‍♂️  Configura Cloud Build e fai il push su Cloud Run.  🧙‍♂️

Suggerimento: un `cloudbuild.yaml` funzionante si trova nella cartella di base e funziona per l'autore. Devi solo modificare e cambiare alcune cose. Qualcosa con cui Gemini CLI può aiutarti!