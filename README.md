# Roku Browser — Cliente (Fase 1)

Consome o JSON gerado pelo servidor de tradução (`roku-browser-server`) e desenha os
elementos na tela usando SceneGraph (`Rectangle` para boxes, `Label` para texto,
`Poster` para imagens).

## Antes de rodar

Edite `components/MainScene.brs` e troque a primeira linha:

```brightscript
m.serverBase = "https://SEU-DEPLOY.vercel.app/api/translate"
```

pela URL real do seu deploy do servidor no Vercel.

Também dá pra trocar a página de teste em `init()` (`m.top.pageUrl`).

## Como funciona

1. `MainScene.init()` dispara `TranslateTask` com a URL do servidor + a página alvo
2. `TranslateTask` roda em thread separada (não trava a UI) e faz `GetToString()`
   na API, depois `ParseJson()` no resultado
3. Quando o campo `content` do Task muda, `OnContentReceived` percorre a árvore JSON
   recursivamente (`BuildAndAppendNode`, em `source/utils.brs`) e cria os nós SceneGraph
4. Como as coordenadas já vêm **absolutas** do servidor, todos os nós são adicionados
   direto no mesmo `Group` (`root`) — a ordem de criação (pai antes dos filhos) já
   garante o z-index certo (fundo atrás, conteúdo na frente)

## Sideload pra testar num Roku de verdade

1. Ativar o modo desenvolvedor no Roku: no controle, pressione Home 3x, Up 2x,
   Rewind, Fast Forward, Rewind, Fast Forward, Rewind (esse é o "Konami code" da Roku)
2. Isso mostra o IP do dispositivo e cria usuário/senha do instalador de dev
3. Zipar o conteúdo desta pasta (manifest na raiz do zip, não dentro de uma subpasta)
4. Acessar `http://IP-DO-ROKU` no navegador, fazer login e subir o `.zip`

## Limitações da fase 1

- Sem interatividade ainda (fase 3 = JS/eventos)
- Sem scroll — se o conteúdo passar da altura da tela, corta
- Fonte é sempre a padrão do sistema (negrito só muda peso "lógico", não troca de família)
- Erros de rede mostram só uma mensagem simples na tela

## Próximos passos

1. Testar contra o servidor real já deployado
2. Adicionar scroll (Group dentro de algo tipo `ScrollingLabel`/rolagem manual por translation)
3. Fase 3: mapear eventos JS simples (onclick) pra navegação/remote input
