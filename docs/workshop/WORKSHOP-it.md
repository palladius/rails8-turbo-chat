## Rails + MCP + Gemini Workshop v1.1.3

<!-- Questo è il documento principale.
Usa `just translate-workshop-to-italian` per tradurre in IT

CHANGELOG
02oct25 v1.1.3 [ricc] [Mac] Ultime modifiche dopo Emiliano 8080->3000->8080
01oct25 v1.1.2 [ricc] [Mac] corretti errori di battitura.
01oct25 v1.1.1 [ricc] Finalizzati TUTTI i capitoli. Sembra a posto ora.
01oct25 v1.1.0 [ricc] Cambiate alcune immagini / rifatte screenshot, commentati alcuni TODO.
01oct25 v1.0.4 [ricc] Aggiunti 2 mazzi di diapositive
01oct25 v1.0.4 [ricc] Inserita la versione nel titolo H1 e rimossi i TODO dalla fine, riformulati come missioni.
29sep25 v1.0.3 [ricc] Rinumerati i titoli per iniziare da 0.
28sep29 v1.0.2 [ricc] Traduzione migliore, spostando git clone DOPO gemini-cli
28sep25 v1.0.1 [ricc] Spostato in docs/workshop/. Aggiunta dipendenza GC e alcuni screenshot carini.
27sep25 v1.0.0 [ricc] ...
-->

🇬🇧 Una versione inglese è disponibile [qui](WORKSHOP.md) 🇬🇧 (e una tedesca [qui](WORKSHOP-de.md) 🇩🇪)

**TL;DR** In questo workshop:

1. Installeremo Gemini CLI.
2. Scaricheremo questa repo e inizieremo a fare qualche domanda a Gemini.
3. Eseguiremo l'app vanilla, senza alcuna magia. Alcune funzionalità non saranno ancora disponibili.
4. Otterremo crediti GCP, recupereremo una 🔑 `GEMINI API KEY` e la inseriremo in `.env`.
5. Riavvieremo l'app e testeremo la magia dell'LLM. Ora la chat risponde in tempo reale e crea immagini fantastiche!
6. Ora iniziamo a giocare con MCP e configuriamo Gemini CLI per connettersi all'MCP della tua app Rails! Ora puoi parlare con la tua app in linguaggio naturale!
7. Creeremo la tua funzione MCP e la testeremo da Gemini CLI!

**Nota**. Il workshop è costellato di 🧙‍♂️ missioni 🧙‍♂️. Se risolvi la missione in un workshop fisico, dillo ai tuoi mentori! Se sei veloce, potresti ricevere un regalo.
**Nota**. Questo workshop è stato creato per il **Devfest Modena**. Potrebbero mancarti informazioni se non sei un partecipante a questo workshop.

Materiale del workshop:

* 🟧 [**Slide del Workshop**](https://docs.google.com/presentation/d/1W4hFU1eckLYMsdI20VyqcL-G1l11vxeeYsgBqfTMpMw/edit?slide=id.g387c805a455_1_446#slide=id.g387c805a455_1_446). Un modo diverso per seguire questo workshop. Nota che questa pagina è più precisa e dettagliata, mentre le slide offrono una visione sinottica di alto livello.
* 🟧 [**Slide per il riscatto dei crediti**](https://docs.google.com/presentation/d/1mY0BwcZERAqilVh4BaQfuX-RyayXrC4N2Pno4tzWcig/edit?slide=id.g337964b5ba0_1_193#slide=id.g337964b5ba0_1_193): qui trovi i link per ottenere crediti GCP. Ne avrai bisogno per il passaggio 3.

## 0. Prerequisiti

* Avere un account **GMail**. Questo è necessario per richiedere i crediti GCP e per consentire l'uso di Gemini LLM!
* `ruby` installato localmente. Raccomandiamo un gestore di versioni come `rbenv`, `rvm`, `asdf` o qualsiasi cosa funzioni per te.
* [opzionale] Un account **GitHub**. Questo è necessario solo se vuoi fare un fork della repo, per utenti avanzati.
* [opzionale] Installa [just](https://github.com/casey/just). Senza di esso, guarda le ricette in `justfile`.

### Installa/Scarica il codice

1. `git clone https://github.com/palladius/rails8-turbo-chat.git`
2. `cp .env.dist .env`: ne avrai bisogno più tardi.

Ricorda la 📂 CARTELLA in cui ti trovi, dovrai lanciare `gemini` da questa esatta cartella.

------

## 1. Installa Gemini CLI (e ottieni informazioni sull'app)

<!-- **Perché**. È probabilmente più facile se gli utenti possono sfruttare Gemini CLI fin dall'inizio. Possono chiedere
1. Cosa fa l'app
2. Di cosa trattava l'ultimo commit, e così via.
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

1. Cambia directory nella cartella dell'app Rails 📂 che hai scaricato prima: `cd path/to/rails8-turbo-chat/`
2. Digita semplicemente: `gemini` e segui il flusso di autenticazione di Google.

Usiamo ora Gemini CLI per una gratificazione immediata:

1. **Di cosa tratta l'app?**
   1. `gemini -p "Spiega l'architettura di questa codebase. Parlami dei modelli Rails e di come interagiscono tra loro"`
   2. Ignora gli errori MCP.
2. **Quali modifiche recenti sono state apportate alla repo?** Questo è un prompt potente per recuperare le modifiche dei tuoi colleghi (o un riepilogo di una modifica che hai fatto ieri sera!)

```bash
$ gemini
## Copia queste 4 righe e incollale in Gemini CLI!
Dammi un riassunto di tutte le modifiche apportate oggi/ieri, in modalità markdown.
Se non ci sono modifiche negli ultimi 2 giorni, prendi invece gli ultimi 3 commit.
Dai un'occhiata a git diff e vedi quali modifiche sono state introdotte e perché. Un punto elenco per hash di commit, per favore.
Salva questo output in `out/git-summary.md`
```
![ultime modifiche](gemini-prompt2.png)

3. **Qual è lo stile di codifica di Riccardo o Christian? Controlla i log di git e aggrega per autore del commit**. Puoi anche fare domande di tipo umano, ovviamente!
   Questo richiederebbe a un essere umano probabilmente 4-5 ore per elaborare i dati.

<!--

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

-->

Trova le risposte di esempio in `docs/workshop/examples/` :)

------

## 2. Gratificazione immediata

<!-- **Perché**. Questo passaggio serve a rendere l'utente felice e coinvolto con il minor sforzo possibile.
-->

In questo passaggio, installi l'app e la fai funzionare

1. `cd rubyllm_chat_app/`
2. Installa ruby e bundler
3. Esegui `bundle install`
4. Esegui `./bin/rails db:setup`
5. Esegui `./bin/rails assets:precompile`
6. Imposta la variabile d'ambiente 'PORT' su 8080
7. `bundle exec rails server` per eseguire il server sulla porta 8080
8. Naviga nel tuo browser a http://localhost:8080/. Dovresti vedere una pagina come quella qui sotto:
![nuova pagina vuota dell'app](missing-gemini-api-key.png)
9. Clicca su "Sign up"
10. Clicca "Sign up" e aggiungi:
    1. La tua **Email**, **Nome**, **Password** e ripetila in **Conferma Password**
![pagina di registrazione](app-signup.png)

11. Fatto! Ora possiamo creare la tua prima chat

![registrazione completata - ora home page](app-loggedin-success.png)


12. Clicca "Start New Chat".
    1. oh oh - questo è rotto! Abbiamo bisogno di una chiave API Gemini.

![esempio di nuova chat](app-chat-example.png)

<!--
TODO(Christian): `rails s` e configurazione DB.
-->

**Nota**. Questo dovrebbe funzionare con tutto tranne le immagini e la chat, quindi forse dovremmo usare una sorta di generazione di DB (`rake db:seed`?) per generare una chat finta. Questo sarà un buon modo per mostrare l'app funzionante senza dover ancora configurare la chiave API: piccoli passi.


### 2B. Chiedi a Gemini CLI del DB

```
Ora trova il file sqlite di sviluppo e mostrami le tabelle.
Mostrami tutto lo schema e crea un DATABASE_INFO.md che contenga:
1. Lo schema che hai trovato.
2. Un grafico Mermaid di tutte le tabelle e di come si interconnettono (chiavi esterne) in modo visuale.
Incorpora tutto nel file markdown. Colora in rosso le tabelle che corrispondono ai modelli in app/models/ e
in GRIGIO tutto il resto.
```

Vedi una possibile risposta in `examples/DATABASE_INFO.md`

![un pezzo dell'analisi risultante..](image-5.png)

* Ora tocca a **te**! Puoi fare QUALSIASI domanda a Gemini CLI - puoi ottenere maggiori dettagli su quelle tabelle e confrontare i risultati dalla vista DB di base con le query ORM (come `echo Chat.last | rails console`)


------

## 3. Ottieni la chiave API Gemini e inizia a creare immagini!

### 3a. Richiedi i crediti GCP..


<!-- **Perché**. In questo passaggio l'utente farà due cose:
    1. recuperare i crediti Cloud per usare Gemini (noioso), ma anche
    2. Usare quei crediti
-->

* recupera i crediti cliccando qui: https://trygcp.dev/e/devfest-modena-25 accedendo con il tuo account Google *personale*.
* Segui il link per ottenere `5$` di crediti. Saranno sufficienti per il workshop.
* Vai su https://aistudio.google.com/apikey e genera una GEMINI API KEY. Annotala localmente nel tuo `.env`, sotto `GEMINI_API_KEY`
* Se sei confuso, controlla queste [slide passo-passo](https://docs.google.com/presentation/d/1mY0BwcZERAqilVh4BaQfuX-RyayXrC4N2Pno4tzWcig/edit?) che il team ha creato per te.

### 3b. .. e usa Gemini FTW!

Ora che hai fatto la parte noiosa, pronto a generare le tue prime immagini?

* Per prima cosa, controlla che Gemini funzioni all'interno dell'app. Il modo più semplice è chiamare `just test-gemini`
* riavvia l'app.
* Assicurati che la chiave API Gemini funzioni
  * Forse assicurati che una chiave API mancante generi un avviso visibile in alto?
  * Se riesci a vedere l'errore, significa che hai sbagliato qualcosa. Se l'errore è scomparso, sei a posto!
![chiave api gemini mancante](missing-gemini-api-key.png)
* Crea una nuova chat.
* Fai una domanda...
  * Osserva la magia: viene generata un'immagine e viene generato anche un riassunto della chat
  * **Prima** (nota che non ho fatto lo screenshot in tempo e il titolo/descrizione erano già cambiati..)
![chat prima della creazione dello screenshot](chat-message-before.png)
  * ... e **dopo** 5 secondi!
![chat dopo la creazione dello screenshot](chat-message-after.png)

### 3c cambia la generazione di immagini


🧙‍♂️ **Missione** 🧙‍♂️ Hai notato che tutte le immagini escono con un cuore giallo e un rubino? Sembra che ci possa essere un easter egg nel codice.

* Trova la parte del codice in cui aggiunge queste 2 "filigrane" (o "watermark") all'immagine
* Cambialo in qualcosa di locale alla tua geografia, ad esempio (per Modena, per includere il volto di Pavarotti).
* Prova la new generation (possibilmente ricaricando l'app)
* Mostra a un supervisore per ottenere il tuo premio.

------

## 4. Testa l'MCP esistente con MCP Inspector

<!--
Qui mostriamo che abbiamo già un MCP pre-costruito
-->

1. Risolviamo i problemi con `npx @modelcontextprotocol/inspector` (il miglior strumento di debug del client MCP a conoscenza dell'autore - segnala un problema se pensi che si sbagli).
2. Clicca sul link dalla CLI (nota il `MCP_PROXY_AUTH_TOKEN`!), qualcosa come: `http://localhost:6274/?MCP_PROXY_AUTH_TOKEN=mys3cr3tt0k3n`
3. Imposta:
   1. Tipo di trasporto: **SSE**
   2. URL: `http://localhost:8080/mcp/sse`
4. Clicca **connetti**.
5. Se funziona, clicca su **Tools**
6. Clicca List Tools.
7. Dovresti vedere questo: ![Elenco degli strumenti su MCP](image1.png)
8. Clicca su uno strumento da eseguire, ad esempio `Chat List`. Goditi un output come questo! Nota che il server MCP sta chiamando ActiveRecord qui!

![Chiamata strumento - chatlist](image2.png)


### 4.A - prova lo stesso sul tuo IDE

Se hai `vscode`, IntelliJ, Claude Code, ora puoi testare MCP. Controlla la configurazione del tuo agente su come aggiungere l'MCP.

#### Aggiungi MCP locale a Gemini CLI


* Usa `gemini mcp` per aggiungere dinamicamente il nostro MCP:
  * `gemini mcp add --transport sse local-rails8-turbo-chat-sse http://localhost:8080/mcp/sse`
  * Questo configurerà gemini per avere questo MCP disponibile.
* **Riavvia** `gemini` (doppio CTRL-C). Gli MCP vengono caricati all'avvio, quindi non dimenticare!
* Digita `/mcp` per assicurarti che sia stato fatto correttamente. Dovresti vedere qualcosa del genere (nota il pulsante verde accanto al nome del server MCP):

![Test /mcp](slash-mcp-just-rails-sse.png)


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

Al tuo file locale (es. `.vscode/settings.json` per Visual Studio code).

Ora puoi interagire con Gemini CLI (o Copilot, Claude, ..) e iniziare a interagire con la tua applicazione con domande come:

* `Recupera un elenco di chat: qualche chat che contiene cibo italiano?`
* `Aggiungi un utente creato "test-workshop@example.com" e password "PincoPallinoJoe" e nome "Test per Workshop"`
![Richieste MCP per chiamare la creazione dell'utente](mcp-create-user-permission.png)
![utente creato correttamente](mcp-create-user.png)
   * `Ora elenca gli utenti` (che dovrebbe anche far emergere il nuovo utente)
![L'elenco mostra anche l'ultimo utente](mcp-example2-list-users.png)
* Chiedi `Usa MCP per rinominare automaticamente tutte le chat`. Questo dovrebbe aggiornare magicamente i titoli delle chat per tutte le chat con nomi errati.

------

## 5. Aggiungi il tuo MCP

**Idee**. Ok, è ora di programmare qualcosa da solo! Puoi essere creativo o prendere spunto da queste idee:

* `what_time_is_it`: Aggiungi una funzione "Che data/ora è".
* `where_am_i`: Chiama un'API esterna per recuperare il meteo locale o la città più vicina.
* *Magia di ActiveRecord*: Un po' di magia di ActiveRecord per contare le relazioni e fornire una statistica (quanti utenti hanno creato quante chat).
  * Forse qualcosa che funzioni bene anche con ActiveStorage? Forse qualcosa che aiuti a risolvere i problemi e a risolvere [questo problema](https://github.com/palladius/rails8-turbo-chat/issues/24)?

<!--
* TODO(Emiliano): qualche idea su cosa possiamo aggiungere qui?
 -->

**Esecuzione**.

Hai un'idea di cosa programmare? Fantastico!

![cartella degli strumenti dell'app](tools-folder.png)

Ora:
1. Aggiungi la tua funzione a `app/tools/` ([cartella](https://github.com/palladius/rails8-turbo-chat/tree/main/rubyllm_chat_app/app/tools)).
2. Ricorda di sottoclassare da `ActionTool::Base`. Maggiori dettagli in https://github.com/yjacquin/fast-mcp
3. Una volta che funziona, carica `rails c` e prova che il codice funzioni come previsto prima.
4. Quindi, ricarica `rails s`; questo assicura che la tua app abbia la nuova funzione!
5. Ora è il momento di testarlo con i tuoi strumenti MCP! Per prima cosa usa Gemini CLI (ricarica anche questo) tramite `/mcp` per verificare che la nuova funzionalità sia apparsa.
6. Prova la funzione ponendo una domanda in linguaggio naturale che corrisponda alla descrizione della funzione (es. "Che ore sono / Dove sono / ...").


------


## 6. [opzionale] Rendi persistenti le immagini su GCS 🧙‍♂️

OMG, sei arrivato qui più velocemente di quanto potessimo documentarlo! È tempo di una sfida!

🧙‍♂️ Impara a rendere persistenti le tue immagini su Google Cloud Storage. La documentazione ufficiale di Active Storage + GCS è [qui](https://guides.rubyonrails.org/active_storage_overview.html#google-cloud-storage-service).
<!--
Questo è un punto di svolta, poiché un push nel cloud renderà persistenti le immagini su computer e tra locale e remoto. Ma è difficile da configurare.
-->


## 7. [opzionale] Prova `docker compose`

🧙‍♂️ Sapevi che Cloud run ora supporta docker-compose in alpha? 🧙‍♂️

Per prima cosa, prova questo localmente:

```bash
cd rubyllm_chat_app/
docker-compose up
docker compose run web todo # TODO(Emiliano) qualche comando come rake db:seed o qualche test diverso
```

Secondo, una volta che riesci a farlo funzionare, prova questo nel Cloud:

```bash
gcloud alpha run compose --help
```

🧙‍♂️ Facci sapere se ce la fai! 🧙‍♂️


<!-- TODO(Emiliano): completa questo -->

Suggerimento: Riccardo ha creato una versione funzionante qui: https://github.com/palladius/rails8-composer-sample/blob/main/README.md segui le briciole di pane del symlink per la soluzione.

Suggerimento: il documento della guida utente Alpha è [qui](https://docs.google.com/document/d/1UJrkn6wnzoHTQjenERhKfvOWPUahBydaWUNF-84B4c8/view?resourcekey=0-qixytbA9n5irnaH3QDyL6g&tab=t.0#heading=h.74iuc6663cso).

## 8. [opzionale] Compila e lancia su Cloud Run tramite `docker compose alpha`

<!-- una volta configurato GCS, e forse Emiliano può aiutare, il resto è un gioco da ragazzi, almeno per Riccardo
TODO(ricc/Emiliano) -->

🧙‍♂️ Configura Cloud Build ed effettua il push su Cloud run. 🧙‍♂️

L'idea è di creare una pipeline CI/CD funzionante in modo che ogni commit/push successivo alla TUA repo.

1. Fai un fork di questa repo su https://github.com/YOUR_USER_NAME/rails8-turbo-chat/
2. Adatta `cloudbuild.yaml` con il tuo ID progetto e i tuoi parametri.
3. Imposta ServiceAccount per esso. Controlla `iac/` per chicche e codice precotto!

Suggerimento: un `cloudbuild.yaml` funzionante si trova nella cartella di base e funziona per l'autore. Lo stesso vale per `iac/` per tutta la configurazione GCP! Devi solo modificare e cambiare alcune cose. Qualcosa con cui Gemini CLI può aiutarti!
