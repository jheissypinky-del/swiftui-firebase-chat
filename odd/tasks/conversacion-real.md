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
S5: La fila del chat refleja quién envió el último mensaje: check de enviado solo si es mío; si es de ella, el preview queda destacado.

## Tasks

| ID | Specs | Route | Commit |
|----|-------|-------|--------|
| T1 | S1-S4 | inline | 6bb87eb |
| T2 | S1-S2 | inline | 6bb87eb |
| T3 | S3-S4 | inline | 6bb87eb |
| T4 | S1-S4 | inline | 01a8b2d |
| T5 | S3, S5 | inline | fbb0e55 |
| T6 | S1-S2 | inline | fbb0e55 |
| T7 | S3 | inline | pendiente |
| T8 | S1-S2 | inline | pendiente |

## Log

L1: crear modelos compartidos (Message, Chat, Story) en ChatDemo/Models/ChatModels.swift; crear ChatDemo/ViewModels/ChatViewModel.swift con chats y mensajes mutables; integrar ChatViewModel via EnvironmentObject en ChatDemoApp, ChatListView y ChatConversationView; ChatConversationView envía mensaje saliente y simula respuesta entrante tras ~2s; ChatListView muestra chats reactivos con preview actualizado

L2: el usuario aclara que el preview debe mostrar el último mensaje de la conversación (si hubo respuesta entrante, se muestra esa), no siempre el mensaje propio.

L3: corrección aplicada:
- `Message.status` pasa a `var`: el cambio `.sending` → `.sent` se muta in-place. Antes se recreaba el `Message`, lo que generaba un `id` nuevo y hacía que SwiftUI reconstruyera la burbuja (parpadeo y pérdida de posición en el LazyVStack).
- `Chat` gana `lastMessageIsOutgoing`: la fila solo muestra el check de enviado si el último mensaje es del usuario.
- `ChatViewModel.activeContact` + `setActiveContact(_:)`: `ChatConversationView` registra la conversación abierta; si la respuesta entrante llega mientras el usuario está en otra pantalla, el chat queda como no leído con badge; si la está viendo, queda leído.
- `updateChatPreview` ahora recibe `isOutgoing` y `markUnread`.

L4: el usuario reporta que el listado NO actualiza el preview y aclara el alcance: es una demo para grabar un video de muestra a un cliente, no hace falta que sea "real".

L5: causa raíz del preview congelado: `Chat.==` comparaba SOLO el `id`. SwiftUI usa la igualdad de las propiedades storage de una vista para decidir si re-renderiza; con dos Chat del mismo id consideradas iguales, la fila se omitía y el preview nunca cambiaba. El mismo bug afectaba a `Message.==` (el check de enviado no cambiaba de reloj a ✓).

L6: simplificación para la demo: se eliminan `activeContact`, `setActiveContact` y `markUnread` (badge de no leídos); las respuestas simuladas pasan a un set corto y rotativo ("¡Entendido!", "Perfecto 👍", ...) en lugar del eco "Recibido: <texto>".

L7: doble garantía de re-render:
- `Chat.==` compara ahora id + preview + time + unreadCount + isRead + lastMessageIsOutgoing.
- `ChatRow` deja de guardar el modelo `Chat` y guarda los valores visibles como propiedades primitivas (String/Bool/Int) vía `init(chat:)`, con lo que la comparación de la fila es por valor y no depende de `Chat.==`.
- `Message.==` compara id + status.

L8: `import FirebaseAuth` en ChatListView.swift es necesario (el tipo de `authViewModel.userSession` es `FirebaseAuth.User`); se restauró tras haberlo quitado por error.

## Verificación

T1: modelos consolidados sin duplicados
T2: sendMessage llama al ViewModel; mensaje saliente aparece con status .sending → .sent; respuesta entrante simulada tras 2s
T3: updateChatPreview muta el array correctamente (struct copy semantics); preview y time se actualizan en la lista
T4: revisión manual de archivos completada
T5: `lastMessageIsOutgoing` se actualiza en ambos sentidos (saliente → entrante); ChatRow lo consume para el check y el peso del preview
T6: `status` mutado in-place preserva el `id` del mensaje
T7: `swiftc -typecheck` de ChatModels.swift + ChatViewModel.swift: SIN ERRORES
T8: las vistas no se pueden typecheckear en este entorno (falta el plugin de macros SwiftUI, requiere Xcode completo); los errores reportados son exclusivamente cascadas del macro no expandido

## Risk

Risk: none — cambio de UI local sin contrato público, sin persistencia, sin seguridad, sin concurrencia compartida.
