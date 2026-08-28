' Converte "#RRGGBBAA" (formato do nosso contrato JSON) para "0xRRGGBBAA"
' (formato aceito pelos campos "color" do SceneGraph)
function ToRokuColor(hex as Dynamic) as String
    if hex = invalid or Len(hex) < 7
        return "0x000000FF"
    end if
    return "0x" + Mid(hex, 2)
end function

' Percorre a árvore JSON (já vem com coordenadas ABSOLUTAS calculadas pelo servidor)
' e cria os nós SceneGraph correspondentes, todos direto no mesmo Group "root".
' Como o traversal é pré-ordem (pai antes dos filhos), a ordem de z-index sai
' correta automaticamente: fundos são adicionados antes do conteúdo por cima.
sub BuildAndAppendNode(nodeJson as Object, root as Object)
    if nodeJson = invalid then return

    nodeType = nodeJson.type
    style = nodeJson.style

    if nodeType = "box"
        if style <> invalid and style.backgroundColor <> invalid
            rect = CreateObject("roSGNode", "Rectangle")
            rect.translation = [nodeJson.x, nodeJson.y]
            rect.width = nodeJson.width
            rect.height = nodeJson.height
            rect.color = ToRokuColor(style.backgroundColor)
            root.appendChild(rect)
        end if

    else if nodeType = "text"
        label = CreateObject("roSGNode", "Label")
        label.translation = [nodeJson.x, nodeJson.y]
        label.width = nodeJson.width
        label.height = nodeJson.height
        label.text = style.content
        label.color = ToRokuColor(style.color)
        label.wrap = true

        font = CreateObject("roSGNode", "Font")
        if style.fontSize <> invalid
            font.size = style.fontSize
        else
            font.size = 16
        end if
        label.font = font

        if style.textAlign <> invalid
            label.horizAlign = style.textAlign
        end if

        root.appendChild(label)

    else if nodeType = "image"
        poster = CreateObject("roSGNode", "Poster")
        poster.translation = [nodeJson.x, nodeJson.y]
        poster.width = nodeJson.width
        poster.height = nodeJson.height
        poster.uri = style.src
        poster.loadDisplayMode = "scaleToFit"
        root.appendChild(poster)
    end if

    children = nodeJson.children
    if children <> invalid
        for each child in children
            BuildAndAppendNode(child, root)
        end for
    end if
end sub
