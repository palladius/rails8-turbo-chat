## Idea per il Workshop 🇮🇹

Una versione in Inglese è disponibile [qui](WORKSHOP.md).

## Prerequisiti

* Avere un account GMail. Questo è necessario per riscattare i crediti GCP e per consentire l'uso di Gemini LLM!  GMail 📧 è fondamentale.
* [opzionale] Avere un account Github. 🐙

## Installazione 💻

1. `git clone https://github.com:palladius/rails8-turbo-chat/`
2. `cd rails8-turbo-chat/`
3. `cp .env.dist .env`: ne avrai bisogno più tardi.
4. `cd rubyllm_chat_app/` - o quello che dice Christian, tipo `workshop/`
5. TODO(Chris): è necessaria una configurazione iniziale?

---

## Passaggio 1. Gratificazione immediata 🚀

<!-- **Perché**. Questo passaggio serve a rendere l'utente felice e coinvolto con il minor sforzo possibile. -->

In questo passaggio, installerai l'app e la farai funzionare.

TODO(Christian): `rails s` e configurazione del DB.

**Nota**. Questo dovrebbe funzionare con tutto tranne le immagini e la chat, quindi forse dovremmo usare una sorta di generazione di DB (`rake db:seed`?) per generare una chat finta. Questo sarà un buon modo per mostrare l'app funzionante senza dover ancora configurare la chiave API: piccoli passi. 👶

---

## Passaggio 2. Ottieni la chiave API di Gemini e inizia a creare immagini 🖼️

### 2a. Riscattare i crediti GCP...

<!-- **Perché**. In questo passaggio l'utente farà due cose:
    1. recuperare i crediti Cloud per usare Gemini (noioso), ma anche
    2. Usare quei crediti
-->

* recupera i crediti cliccando qui: https://trygcp.dev/e/devfest-maudna-25 accedendo con il tuo account Google *personale*.
* Segui il link per ottenere `5$` in crediti. Saranno sufficienti per il workshop.
* Vai su https://aistudio.google.com/apikey e genera una CHIAVE API GEMINI. Annotala localmente nel tuo file `.env`, sotto `GEMINI_API_KEY`

### 2b. ... e usa Gemini FTW! 🎉

Ora che hai fatto la parte noiosa, pronto a generare le tue prime immagini?

* riavvia l'app.
* Assicurati che la chiave API di Gemini funzioni
  * Forse assicurati che una chiave API mancante generi un avviso visibile in alto?
* Crea una nuova chat.
* Fai una domanda...
  * Osserva la magia: viene generata un'immagine e anche una sinossi della chat
  * TODO riccc: screenshot prima
  * TODO riccc: screenshot dopo

---

## Passaggio 3. Testa l'MCP esistente 🧪

<!--
Qui mostriamo che abbiamo già un MCP pre-costruito
-->

1. Facciamo troubleshooting con `npx @modelcontextprotocol/inspector`
2. Clicca sul link dalla CLI (nota il MCP_PROXY_AUTH_TOKEN!), qualcosa come: `http://localhost:6274/?MCP_PROXY_AUTH_TOKEN=blahblahblah`
3. Configurazione:
   1. Tipo di trasporto: **SSE**
   2. URL: `https://localhost:8080/mcp/sse` - TODO(Christian), mi confermi che usiamo 8080? o 3000?
4. Clicca su **connect**.
5. Se funziona, clicca su **Tools**
6. Clicca su `List Tools`.
7. Dovresti vedere questo: ![Elenco degli strumenti su MCP](docs/workshop/image1.png)
8. Clicca su uno strumento per eseguirlo, ad esempio `Chat List`. Goditi un output come questo! Nota che il server MCP sta chiamando ActiveRecord qui!

![Esecuzione dello strumento - chatlist](docs/workshop/image2.png)

### Opzionale - testa lo stesso su vscode 🧑‍💻

1. Aggiungi `https://localhost:8080/mcp/sse` al tuo vscode, ad esempio in `.vscode/settings.json`.
2. Chiedi a Copilot o Claude o al tuo client preferito qualcosa come "Recupera un elenco di chat: qualche chat che contiene cibo italiano?"

---

## Passaggio 4. Aggiungi il tuo MCP personale 🧑‍🔧

Ok, è ora di programmare qualcosa da solo!

TODO(Chris): qualche idea su cosa possiamo aggiungere qui?
Dovremmo aggiungere qualcosa in `app/tools/`

* Idea di Ricc: forse potremmo:
* 1. aggiungere una migrazione che aggiunge un nickname o un `modenese_nickname` alla classe User
* 2. eseguire la migrazione e aggiornare il DB
* 3. Testarlo localmente con `rails console`.
* 4. Una volta che funziona, ricarica l'MCP e chiedi

---

## Passaggio 5. Installa Gemini CLI e aggiungi questo.

* Installa [Gemini CLI](https://github.com/google-gemini/gemini-cli) con npm:
  * `npm install -g @google/gemini-cli`
  * Vedi la homepage per [installazioni alternative](https://github.com/google-gemini/gemini-cli?tab=readme-ov-file#-installation).
* Usa `gemini mcp` per aggiungere dinamicamente il nostro MCP:
  * `gemini mcp add --transport sse local-rails8-turbo-chat-sse https://localhost:8000/mcp/sse`
  * Questo configurerà gemini per avere questo MCP disponibile
* Avvia Gemini
* Chiedi "Quali sono i miei utenti?" (se non funziona: "Usa MCP per recuperare i miei utenti").
* Chiedi "Usa MCP per rinominare automaticamente tutte le chat".
  * Questo dovrebbe aggiornare magicamente i titoli delle chat per tutte le chat con nomi errati.

## Passaggio 6. [opzionale] Rendi persistenti le immagini su GCS ☁️

<!--
Questo è un punto di svolta, poiché un push sul cloud renderà persistenti le immagini su più computer e tra locale e remoto. Ma è difficile da configurare.
-->

TODO(Emiliano)

## Passaggio 7. [opzionale] Compila e lancia su Cloud Run 🚀

<!-- una volta configurato GCS, e forse Emiliano può aiutare, il resto è un gioco da ragazzi, almeno per Riccardo -->

TODO(ricc)
