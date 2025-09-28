## Idea per il Workshop 🇮🇹

<!-- Questo è il documento principale v1.0.1.
Usa `just translate-workshop-to-italian` per tradurlo in IT

CHANGELOG
28sep25 v1.0.1 [ricc] Spostato in docs/workshop/. Aggiunta dipendenza da GC e alcuni screenshot carini.
27sep25 v1.0.0 [ricc] ...

-->

Una versione italiana è disponibile [qui](WORKSHOP-it.md).

## Prerequisiti 📋

*   Avere un account GMail. Questo è necessario per richiedere i crediti GCP e per permettere l'uso di Gemini LLM! 🚀
*   [opzionale] Avere un account Github. Questo è necessario solo se si vuole fare un fork del repo, per utenti avanzati. 🤓
*   [opzionale] Installare `just`. In caso contrario, basta guardare le ricette in `justfile`. 📜

## Installa/Scarica il codice 💻

1.  `git clone https://github.com:palladius/rails8-turbo-chat/`
2.  `cd rails8-turbo-chat/`
3.  `cp .env.dist .env`: ti servirà più tardi.

------

## Passo 0. Installa Gemini CLI (e ottieni informazioni sull'app) 🕵️‍♂️

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

Altre opzioni di installazione [qui].(https://github.com/google-gemini/gemini-cli)

Per **avviare** Gemini CLI, digita semplicemente: `gemini` e segui il flusso di autenticazione di Google.

Ora usiamo Gemini CLI per una gratificazione immediata:

1.  **Di cosa parla l'app?**
    1.  `gemini -p "Spiega l'architettura di questa codebase. Parlami dei modelli Rails e di come interagiscono tra loro"`
2.  **Quali modifiche recenti sono state apportate al repo?**. Questo è un prompt potente per recuperare le modifiche dei tuoi colleghi (o un riepilogo di una modifica che hai fatto ieri sera!)

```bash
$ gemini
Dammi un riassunto di tutte le modifiche apportate oggi/ieri, in modalità markdown.
Se non ci sono modifiche negli ultimi 2 giorni, prendi invece gli ultimi 3 commit.
Dai un'occhiata a git diff e vedi quali modifiche sono state introdotte e perché. Un punto elenco per hash di commit, per favore.
Salva questo output in `git-summary.md`
```

3.  **Qual è lo stile di codifica di Riccardo o Christian?**. Puoi anche fare domande di tipo umano!

```bash
$ gemini
Controlla gli ultimi 3 commit di:
- Christian
- Emiliano
- Riccardo
Dai un'occhiata al codice in git diff e fornisci due informazioni per persona:
1. Che stile di codifica hanno
2. Che tipo di codice tendono a modificare (frontend, backend, GCP, Docs, ..)
Salva questo output in `people-style-summary.md`
```

Trova le risposte di esempio in `docs/workshop/` :)
------

## Passo 1. Gratificazione immediata 🎉

<!-- **Perché**. Questo passo serve a rendere l'utente felice e coinvolto con il minor sforzo possibile.
-->

In questo passo, installerai l'app e la farai funzionare

1.  `cd rubyllm_chat_app/` - o quel che dice Christian, tipo workshop/ TODO(Christian)
2.  TODO(Chris): è necessaria una configurazione iniziale?
3.  [ricc] `rails db:migrate` # per migrare il DB
4.  [ricc] `rails server` per avviare il server sulla porta 8080
5.  Naviga con il tuo browser a http://localhost:8080/ . Dovresti vedere una pagina come quella qui sotto:
    ![nuova app pagina vuota](image.png)
6.  Clicca su "Sign up" e aggiungi:
    1.  La tua **Email**, **Nome**, **Password** e ripetila in **Conferma Password**
    2.  Lascia vuota la *Gemini API Key* (non è necessaria ora).
    ![pagina di registrazione](image-1.png)
7.  Fatto! È ora di creare la tua prima chat
    ![registrazione riuscita](image-2.png)
8.  Clicca su "Start New Chat".
    1.  oh oh - questo è rotto! Abbiamo bisogno di una Gemini API Key.

TODO(Christian): `rails s` e configurazione del DB.

**Nota**. Questo dovrebbe funzionare con tutto tranne le immagini e la chat, quindi forse dovremmo usare una sorta di generazione del DB (`rake db:seed` ?) per generare una chat finta. Questo sarà un buon modo per mostrare l'app funzionante senza dover ancora configurare la chiave API: piccoli passi.

------

## Passo 2. Ottieni la Gemini API Key e inizia a creare immagini. 🖼️

### 2a. Richiedi i crediti GCP..

<!-- **Perché**. In questo passo l'utente farà due cose:
    1. recuperare i crediti Cloud per usare Gemini (noioso), ma anche
    2. Usare quei crediti
-->

*   recupera i crediti cliccando qui: https://trygcp.dev/e/devfest-maudna-25 accedendo con il tuo account Google *personale*.
*   Segui il link per ottenere `5$` in crediti. Saranno sufficienti per il workshop.
*   Vai su https://aistudio.google.com/apikey e genera una GEMINI API KEY. Annotala localmente nel tuo `.env`, sotto `GEMINI_API_KEY`

### 2b. .. e usa Gemini FTW! 💪

Ora che hai fatto la parte noiosa, pronto a generare le tue prime immagini?

*   Prima di tutto, controlla che Gemini funzioni all'interno dell'app. Il modo più semplice è chiamare
    *   `just test-gemini`
*   riavvia l'app.
*   Assicurati che la Gemini API Key funzioni
    *   Forse assicurati che una chiave API mancante generi un avviso visibile in alto?
    *   Se riesci a vedere l'errore, significa che hai sbagliato qualcosa. Se l'errore è scomparso, sei a posto!
    ![chiave api gemini mancante](image-3.png)
*   Crea una nuova chat.
*   Fai una domanda...
    *   Osserva la magia: viene generata un'immagine e anche una sinossi della chat
    *   TODO riccc: screenshot prima
    *   TODO riccc: screenshot dopo

------

## Passo 3. Testa l'MCP esistente 🧪

<!--
Qui mostriamo che abbiamo già un MCP pre-costruito
-->

1.  Risolviamo i problemi con `npx @modelcontextprotocol/inspector`
2.  Clicca sul link dalla CLI (nota il MCP_PROXY_AUTH_TOKEN!), qualcosa come: `http://localhost:6274/?MCP_PROXY_AUTH_TOKEN=blahblahblah`
3.  Imposta:
    1.  Tipo di trasporto: **SSE**
    2.  URL: `https://localhost:8080/mcp/sse` - TODO(Christian), mi confermi che usiamo 8080? o 3000?
4.  Clicca su **connect**.
5.  Se funziona, clicca su **Tools**
6.  Clicca su List Tools.
7.  Dovresti vedere questo: ![Elenco degli strumenti su MCP](docs/workshop/image1.png)
8.  Clicca su uno strumento per eseguirlo, ad esempio `Chat List`. Goditi un output come questo! Nota che il server MCP sta chiamando ActiveRecord qui!

![Chiamata strumento - chatlist](docs/workshop/image2.png)

### Opzionale - testa lo stesso su vscode

1.  Aggiungi https://localhost:8080/mcp/sse al tuo vscode, ad esempio in `.vscode/settings.json`.
2.  Chiedi a Copilot o Claude o al tuo client preferito qualcosa come "Recupera un elenco di chat: qualche chat che contiene cibo italiano?"

------

## Passo 4. Aggiungi il tuo MCP personale 👨‍💻

Ok, è ora di programmare qualcosa da solo!

TODO(Chris): qualche idea su cosa possiamo aggiungere qui?
Dovremmo aggiungere qualcosa a app/tools/

*   Idea di Ricc: forse potremmo:
*   1. aggiungere una migrazione che aggiunge un nickname o un `modenese_nickname` alla classe User
*   2. eseguire la migrazione e aggiornare il DB
*   3. Testarlo localmente con `rails console`.
*   4. Una volta che funziona, ricarica l'MCP e chiedi

------

## Passo 5. Installa Gemini CLI e aggiungi questo. 🚀

*   Installa [Gemini CLI](https://github.com/google-gemini/gemini-cli) con npm:
    *   `npm install -g @google/gemini-cli`
    *   Vedi la homepage per [installazioni alternative](https://github.com/google-gemini/gemini-cli?tab=readme-ov-file#-installation).
*   Usa `gemini mcp` per aggiungere dinamicamente il nostro MCP:
    *   `gemini mcp add --transport sse local-rails8-turbo-chat-sse https://localhost:8000/mcp/sse`
    *   Questo configurerà gemini per avere questo MCP disponibile
*   Avvia Gemini
*   Chiedi "Quali sono i miei utenti?" (se non funziona: "Usa MCP per recuperare i miei utenti").
*   Chiedi "Usa MCP per rinominare automaticamente tutte le chat".
    *   Questo dovrebbe aggiornare magicamente i titoli delle chat per tutte le chat con nomi errati.

## Passo 6. [opzionale] Rendi persistenti le immagini su GCS ☁️

<!--
Questo è un punto di svolta, poiché un push sul cloud renderà persistenti le immagini tra computer e tra locale e remoto. Ma è difficile da configurare.
-->

TODO(Emiliano)

## Passo 7. [opzionale] Compila e lancia su Cloud Run 🚀

<!-- una volta configurato GCS, e forse Emiliano può aiutare, il resto è un gioco da ragazzi, almeno per Riccardo -->

TODO(ricc)
