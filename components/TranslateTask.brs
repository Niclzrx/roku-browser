sub init()
    m.top.functionName = "FetchAndTranslate"
end sub

sub FetchAndTranslate()
    url = m.top.serverUrl

    xfer = CreateObject("roUrlTransfer")
    xfer.SetUrl(url)
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.InitClientCertificates()
    xfer.AddHeader("Accept", "application/json")

    response = xfer.GetToString()

    if response = invalid or response = ""
        m.top.content = invalid
        return
    end if

    parsed = ParseJson(response)
    if parsed = invalid
        m.top.content = invalid
        return
    end if

    m.top.content = parsed
end sub
