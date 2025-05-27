# Entity Relationship Diagram

This document explains the main models in the application and visualizes their relationships using a Mermaid.js Entity Relationship Diagram.

## Model Descriptions

*   **User:** Represents a user of the application. Users can have multiple chats.
*   **Chat:** Represents a single conversation thread. Each chat belongs to a user and contains multiple messages.
*   **Message:** Represents a single message within a chat. Messages belong to a chat and can be associated with a tool call.
*   **ToolCall:** Represents a call to an external tool initiated by the assistant. Each tool call is associated with a specific assistant message.

## ER Diagram

```mermaid
graph LR;
erDiagram
    User {
        string email
        string encrypted_password
        string name
        string gemini_api_key
        datetime created_at
        datetime updated_at
    }

    Chat {
        string model_id
        string title
        datetime created_at
        datetime updated_at
        int user_id FK
    }

    Message {
        string role
        text content
        datetime created_at
        datetime updated_at
        int chat_id FK
    }

    ToolCall {
        string tool_call_id
        string name
        jsonb arguments
        datetime created_at
        datetime updated_at
        int message_id FK
    }

    User ||--o{ Chat : has
    Chat ||--o{ Message : contains
    Message ||--o| ToolCall : initiates
```


## Prompt

I've used this to create this page:

* “Create a doc/er_diagram.md file which contains an explanation of what each model in app/models/ does, and fill it with a mermaid.js E/R diagram so it visualizes beautifully on github while also be easy to maintain as text”.*

Prompt2:

* Silly question. the diagram has a huge verticality so it renders horribly on a picture (factor of shape is like 5 to 1). Can you force the 4 entities to be in some sort of square, like in a 2x2 square? I dont care where they are just theyf it in a square-ish.
