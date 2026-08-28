' ATENÇÃO: troque pela URL real do seu deploy no Vercel (sem a barra final)
m.serverBase = "https://SEU-DEPLOY.vercel.app/api/translate"

sub init()
    m.root = m.top.findNode("root")

    ' URL de teste padrão — pode ser trocada via m.top.pageUrl a partir de outra tela
    if m.top.pageUrl = invalid or m.top.pageUrl = ""
        m.top.pageUrl = "https://exemplo.com"
    end if

    StartTranslation(m.top.pageUrl)
end sub

sub onPageUrlChange()
    ' limpa o conteúdo anterior antes de buscar a nova página
    m.root.removeChildren(m.root.getChildren(-1, 0))
    StartTranslation(m.top.pageUrl)
end sub

sub StartTranslation(pageUrl as String)
    m.task = CreateObject("roSGNode", "TranslateTask")
    m.task.serverUrl = m.serverBase + "?url=" + HttpEncode(pageUrl)
    m.task.ObserveField("content", "OnContentReceived")
    m.task.control = "RUN"
end sub

sub OnContentReceived(event as Object)
    content = event.GetData()

    if content = invalid
        errorLabel = CreateObject("roSGNode", "Label")
        errorLabel.translation = [80, 80]
        errorLabel.width = 1120
        errorLabel.text = "Não foi possível carregar a página."
        errorLabel.color = "0xFF4444FF"
        m.root.appendChild(errorLabel)
        return
    end if

    rootNode = content.root
    if rootNode <> invalid
        BuildAndAppendNode(rootNode, m.root)
    end if
end sub

' Escapa a URL de destino pra usar como query param
function HttpEncode(str as String) as String
    xfer = CreateObject("roUrlTransfer")
    return xfer.Escape(str)
end function
