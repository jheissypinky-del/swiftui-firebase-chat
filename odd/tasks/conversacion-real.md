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
S3: Al regresar a ChatListView, el chat muestra el **último mensaje de la conversación** como `preview` con `time` "Ahora" (si la otra persona respondió, el preview es su respuesta).
S4: La lista de chats refleja los cambios sin reiniciar la app.
S5: La fila del chat refleja quién envió el último mensaje: check de enviado solo si es mío; si es de ella, preview destacado y badge de no leídos cuando el usuario no está en esa conversación.

## Tasks

| ID | Specs | Route | Commit |
|----|-------|-------|--------|
| T1 | S1-S4 | inline | 6bb87eb |
| T2 | S1-S2 | inline | 6bb87eb |
| T3 | S3-S4 | inline | 6bb87eb |
| T4 | S1-S4 | inline | 01a8b2d (revisión manual) |
| T5 | S3, S5 | inline | pendiente |
| T6 | S1-S2 | inline | pendiente |

## Log

L1: crear modelos compartidos (Message, Chat, Story) en ChatDemo/Models/ChatModels.swift; crear ChatDemo/ViewModels/ChatViewModel.swift con chats y mensajes mutables; integrar ChatViewModel via EnvironmentObject en ChatDemoApp, ChatListView y ChatConversationView; ChatConversationView envía mensaje saliente y simula respuesta entrante tras ~2s; ChatListView muestra chats reactivos con preview actualizado

L2: el usuario aclara que el preview debe mostrar el último mensaje de la conversación (si hubo respuesta entrante, se muestra esa), no siempre el mensaje propio.

L3: corrección aplicada:
- `Message.status` pasa a `var`: el cambio `.sending` → `.sent` se muta in-place. Antes se recreaba el `Message`, lo que generaba un `id` nuevo y hacía que SwiftUI reconstruyera la burbuja (parpadeo y pérdida de posición en el LazyVStack).
- `Chat` gana `lastMessageIsOutgoing`: la fila solo muestra el check de enviado si el último mensaje es del usuario.
- `ChatViewModel.activeContact` + `setActiveContact(_:)`: `ChatConversationView` registra la conversación abierta; si la respuesta entrante llega mientras el usuario está en otra pantalla, el chat queda como no leído con badge; si la está viendo, queda leído.
- `updateChatPreview` ahora recibe `isOutgoing` y `markUnread`.

## Verificación

T1: modelos consolidados sin duplicados
T2: sendMessage llama al ViewModel; mensaje saliente aparece con status .sending → .sent; respuesta entrante simulada tras 2s
T3: updateChatPreview muta el array correctamente (struct copy semantics); preview y time se actualizan en la lista
T4: revisión manual de archivos completada (no hay Xcode disponible para compilar)
T5: `lastMessageIsOutgoing` se actualiza en ambos sentidos (saliente → entrante); ChatRow lo consume para el check y el peso del preview
T6: `status` mutado in-place preserva el `id` del mensaje

## Risk

Risk: none — cambio de UI local sin contrato público, sin persistencia, sin seguridad, sin concurrencia compartida.
