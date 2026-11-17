# Feature: Conversación real (mensaje saliente + respuesta entrante + preview en lista)

## Objetivo
Al enviar un mensaje desde la conversación, debe aparecer como saliente en la vista actual; a continuación se simula un mensaje entrante de la otra persona; y al regresar a la lista de mensajes, ese chat debe mostrar el mensaje enviado como preview del último mensaje con hora actualizada.

## Rama
main

## Estrategia de entrega
ask-on-risk (default)

## Test runner
swift test / xcodebuild (proyecto SwiftUI)

## Specs

S1: Al pulsar enviar en ChatConversationView, el texto se añade como mensaje saliente (isOutgoing: true) y se muestra en la conversación.
S2: Tras enviar, se simula un mensaje entrante de la misma persona (isOutgoing: false) tras un breve retraso.
S3: Al regresar a ChatListView, el chat de esa persona muestra el último mensaje enviado como `preview` y el `time` como "Ahora".
S4: La lista de chats refleja los cambios sin reiniciar la app.

## Tasks

| ID | Specs | Route | Commit |
|----|-------|-------|--------|
| T1 | S1-S4 | inline | 4a380ac (prev) + nuevo commit |
| T2 | S1-S2 | inline | — |
| T3 | S3-S4 | inline | — |
| T4 | S1-S4 | inline | — |

## Log

L1: crear modelos compartidos (Message, Chat, Story) en ChatDemo/Models/ChatModels.swift; crear ChatDemo/ViewModels/ChatViewModel.swift con chats y mensajes mutables; integrar ChatViewModel via EnvironmentObject en ChatDemoApp, ChatListView y ChatConversationView; ChatConversationView envía mensaje saliente y simula respuesta entrante tras ~2s; ChatListView muestra chats reactivos con preview actualizado

## Verificación

T1: modelos consolidados sin duplicados
T2: sendMessage llama al ViewModel; mensaje saliente aparece con status .sending → .sent; respuesta entrante simulada tras 2s
T3: updateChatPreview muta el array correctamente (struct copy semantics); preview y time se actualizan en la lista
T4: revisión manual de archivos completada (no hay Xcode disponible para compilar)

## Risk

Risk: none — cambio de UI local sin contrato público, sin persistencia, sin seguridad, sin concurrencia compartida.
