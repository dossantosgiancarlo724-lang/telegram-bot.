$Token = $env:TELEGRAM_BOT_TOKEN
if ([string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "ERRORE: variabile d'ambiente TELEGRAM_BOT_TOKEN non impostata." -ForegroundColor Red
    exit 1
}
$Api = "https://api.telegram.org/bot$Token"

$OwnerId = 8816533518
$ChannelId = "-1004496464649"
$PriceStars = 350

$VideoIds = @(
    "BAACAgEAAxkBAAMEanXvgwUhWw_z1Aj04KoyiqXuonkAAkgIAAJJSrBHwjZ0ElIw9qg9BA",
    "BAACAgEAAxkBAAMGanXwThByLyuRaEAlFTrss9FPDDsAAkoIAAJJSrBHmkAdcyDjSYs9BA",
    "BAACAgEAAxkBAAMHanXwYf4b7BpkrSeRJCr3-KlL3U4AAksIAAJJSrBHsw74GRrMvLU9BA",
    "BAACAgEAAxkBAAMIanXwaCORE1OQsl23m3-zBkY3Ls8AAkwIAAJJSrBHTdlQRuVLmjc9BA",
    "BAACAgEAAxkBAAMJanXwm5_6iKsIO3TRVYbCUizVZq8AAk0IAAJJSrBHeUFFP1mUpUE9BA"
)

$Texts = @{
    en = @{
        WelcomeTitle = "VIP PREVIEW ACCESS"
        WelcomeBody  = "Choose your language below."
        MenuBody     = "Choose one option below."
        StartBtn     = "Watch free preview"
        BuyBtn       = "Unlock full access - 350 Stars"
        LangBtn      = "Change language"
        Active       = "Your free preview is now active for 60 seconds."
        End          = "Preview ended. Temporary content has been removed."
        PreviewUsed  = "You have already used your free preview."
        PayText      = "To unlock the private channel, complete the payment of 350 Stars."
        InvoiceTitle = "Private channel access"
        InvoiceDesc  = "One-time access purchase for the private Telegram channel."
        InvoiceLabel = "Private channel access"
        Paid         = "Payment received successfully. Your private access link is ready below."
        JoinBtn      = "Join private channel"
        PayError     = "Payment could not be opened right now."
    }
    it = @{
        WelcomeTitle = "ACCESSO PREVIEW VIP"
        WelcomeBody  = "Scegli la lingua qui sotto."
        MenuBody     = "Scegli una delle opzioni qui sotto."
        StartBtn     = "Guarda preview gratuita"
        BuyBtn       = "Sblocca accesso completo - 350 Stelle"
        LangBtn      = "Cambia lingua"
        Active       = "La tua preview gratuita e ora attiva per 60 secondi."
        End          = "Preview terminata. I contenuti temporanei sono stati rimossi."
        PreviewUsed  = "Hai gia usato la tua preview gratuita."
        PayText      = "Per sbloccare il canale privato, completa il pagamento di 350 Stelle."
        InvoiceTitle = "Accesso canale privato"
        InvoiceDesc  = "Acquisto di accesso singolo al canale Telegram privato."
        InvoiceLabel = "Accesso canale privato"
        Paid         = "Pagamento ricevuto con successo. Il tuo link di accesso privato e pronto qui sotto."
        JoinBtn      = "Entra nel canale privato"
        PayError     = "Non e stato possibile aprire il pagamento in questo momento."
    }
    fr = @{
        WelcomeTitle = "ACCES PREVIEW VIP"
        WelcomeBody  = "Choisissez votre langue ci-dessous."
        MenuBody     = "Choisissez une option ci-dessous."
        StartBtn     = "Voir la preview gratuite"
        BuyBtn       = "Debloquer l'acces complet - 350 Stars"
        LangBtn      = "Changer la langue"
        Active       = "Votre preview gratuite est maintenant active pendant 60 secondes."
        End          = "Preview terminee. Le contenu temporaire a ete supprime."
        PreviewUsed  = "Vous avez deja utilise votre preview gratuite."
        PayText      = "Pour debloquer le canal prive, effectuez le paiement de 350 Stars."
        InvoiceTitle = "Acces au canal prive"
        InvoiceDesc  = "Achat d'acces unique au canal Telegram prive."
        InvoiceLabel = "Acces au canal prive"
        Paid         = "Paiement recu avec succes. Votre lien d'acces prive est pret ci-dessous."
        JoinBtn      = "Rejoindre le canal prive"
        PayError     = "Impossible d'ouvrir le paiement pour le moment."
    }
    ru = @{
        WelcomeTitle = "VIP PREVIEW ACCESS"
        WelcomeBody  = "Vyberite yazyk nizhe."
        MenuBody     = "Vyberite odin iz variantov nizhe."
        StartBtn     = "Smotret besplatnuyu preview"
        BuyBtn       = "Otkryt polnyy dostup - 350 Stars"
        LangBtn      = "Smenit yazyk"
        Active       = "Vasha besplatnaya preview aktivna 60 sekund."
        End          = "Preview zavershena. Vremennyy kontent udalen."
        PreviewUsed  = "Vy uzhe ispolzovali besplatnuyu preview."
        PayText      = "Chtoby otkryt privatnyy kanal, oplatite 350 Stars."
        InvoiceTitle = "Dostup k privatnomu kanalu"
        InvoiceDesc  = "Razovaya pokupka dostupa k privatnomu Telegram-kanalu."
        InvoiceLabel = "Dostup k privatnomu kanalu"
        Paid         = "Platezh uspeshno poluchen. Vasha privatnaya ssylka gotova nizhe."
        JoinBtn      = "Voyti v privatnyy kanal"
        PayError     = "Ne udalos otkryt platezh v dannyy moment."
    }
    es = @{
        WelcomeTitle = "ACCESO PREVIEW VIP"
        WelcomeBody  = "Elige tu idioma abajo."
        MenuBody     = "Elige una opcion abajo."
        StartBtn     = "Ver preview gratuita"
        BuyBtn       = "Desbloquear acceso completo - 350 Stars"
        LangBtn      = "Cambiar idioma"
        Active       = "Tu preview gratuita esta activa durante 60 segundos."
        End          = "Preview finalizada. El contenido temporal ha sido eliminado."
        PreviewUsed  = "Ya has usado tu preview gratuita."
        PayText      = "Para desbloquear el canal privado, completa el pago de 350 Stars."
        InvoiceTitle = "Acceso al canal privado"
        InvoiceDesc  = "Compra de acceso unico al canal privado de Telegram."
        InvoiceLabel = "Acceso al canal privado"
        Paid         = "Pago recibido correctamente. Tu enlace de acceso privado esta listo abajo."
        JoinBtn      = "Entrar al canal privado"
        PayError     = "No se pudo abrir el pago en este momento."
    }
    pt = @{
        WelcomeTitle = "ACESSO PREVIEW VIP"
        WelcomeBody  = "Escolha seu idioma abaixo."
        MenuBody     = "Escolha uma opcao abaixo."
        StartBtn     = "Ver preview gratuita"
        BuyBtn       = "Desbloquear acesso completo - 350 Stars"
        LangBtn      = "Mudar idioma"
        Active       = "Sua preview gratuita esta ativa por 60 segundos."
        End          = "Preview encerrada. O conteudo temporario foi removido."
        PreviewUsed  = "Voce ja usou sua preview gratuita."
        PayText      = "Para desbloquear o canal privado, conclua o pagamento de 350 Stars."
        InvoiceTitle = "Acesso ao canal privado"
        InvoiceDesc  = "Compra de acesso unico ao canal privado do Telegram."
        InvoiceLabel = "Acesso ao canal privado"
        Paid         = "Pagamento recebido com sucesso. Seu link de acesso privado esta pronto abaixo."
        JoinBtn      = "Entrar no canal privado"
        PayError     = "Nao foi possivel abrir o pagamento agora."
    }
}

$UserLang = @{}
$PreviewUsed = @{}
$UserNames = @{}

function TgPostJson {
    param([string]$Method,[hashtable]$Payload)
    $Json = $Payload | ConvertTo-Json -Depth 20 -Compress
    Invoke-RestMethod -Uri "$Api/$Method" -Method Post -ContentType "application/json" -Body $Json
}

function GetDisplayName {
    param($User)
    if ($null -ne $User.username -and $User.username -ne "") {
        return "$($User.first_name) (@$($User.username))"
    }
    return "$($User.first_name)"
}

function SendText {
    param([long]$ChatId,[string]$Text,$Keyboard = $null)
    $Payload = @{ chat_id = $ChatId; text = $Text }
    if ($null -ne $Keyboard) { $Payload.reply_markup = $Keyboard }
    TgPostJson -Method "sendMessage" -Payload $Payload
}

function EditText {
    param([long]$ChatId,[int]$MessageId,[string]$Text,$Keyboard = $null)
    $Payload = @{ chat_id = $ChatId; message_id = $MessageId; text = $Text }
    if ($null -ne $Keyboard) { $Payload.reply_markup = $Keyboard }
    try { TgPostJson -Method "editMessageText" -Payload $Payload | Out-Null }
    catch { SendText -ChatId $ChatId -Text $Text -Keyboard $Keyboard | Out-Null }
}

function GetLanguageKeyboard {
    @{
        inline_keyboard = @(
            @(
                @{ text = "English"; callback_data = "lang_en" },
                @{ text = "Italiano"; callback_data = "lang_it" }
            ),
            @(
                @{ text = "Francais"; callback_data = "lang_fr" },
                @{ text = "Russkiy"; callback_data = "lang_ru" }
            ),
            @(
                @{ text = "Espanol"; callback_data = "lang_es" },
                @{ text = "Portugues"; callback_data = "lang_pt" }
            )
        )
    }
}

function GetMainKeyboard {
    param([string]$Lang)
    @{
        inline_keyboard = @(
            @(@{ text = $Texts[$Lang].StartBtn; callback_data = "start_preview" }),
            @(@{ text = $Texts[$Lang].BuyBtn; callback_data = "buy_access" }),
            @(@{ text = $Texts[$Lang].LangBtn; callback_data = "back_lang" })
        )
    }
}

function SendPreviewAlbumAsync {
    param([long]$ChatId,[string]$Lang,[string[]]$VideoIds,[string]$Token)

    Start-Job -ScriptBlock {
        param($ChatId,$VideoIds,$Token,$EndText,$StartBtn,$BuyBtn,$LangBtn)

        $Api = "https://api.telegram.org/bot$Token"

        $Media = @()
        foreach ($id in $VideoIds) {
            $Media += @{ type = "video"; media = $id }
        }

        $Album = Invoke-RestMethod -Uri "$Api/sendMediaGroup" -Method Post -ContentType "application/json" -Body ((@{
            chat_id = $ChatId
            media = $Media
            protect_content = $true
        }) | ConvertTo-Json -Depth 20 -Compress)

        Start-Sleep -Seconds 60

        foreach ($msg in $Album.result) {
            try {
                Invoke-RestMethod -Uri "$Api/deleteMessage" -Method Post -ContentType "application/json" -Body ((@{
                    chat_id = $ChatId
                    message_id = $msg.message_id
                }) | ConvertTo-Json -Compress) | Out-Null
            } catch {}
        }

        $Keyboard = @{
            inline_keyboard = @(
                @(@{ text = $StartBtn; callback_data = "start_preview" }),
                @(@{ text = $BuyBtn; callback_data = "buy_access" }),
                @(@{ text = $LangBtn; callback_data = "back_lang" })
            )
        }

        Invoke-RestMethod -Uri "$Api/sendMessage" -Method Post -ContentType "application/json" -Body ((@{
            chat_id = $ChatId
            text = $EndText
            reply_markup = $Keyboard
        }) | ConvertTo-Json -Depth 20 -Compress) | Out-Null
    } -ArgumentList $ChatId,$VideoIds,$Token,$Texts[$Lang].End,$Texts[$Lang].StartBtn,$Texts[$Lang].BuyBtn,$Texts[$Lang].LangBtn | Out-Null
}

function SendStarsInvoice {
    param([long]$ChatId,[string]$Lang)
    TgPostJson -Method "sendInvoice" -Payload @{
        chat_id = $ChatId
        title = $Texts[$Lang].InvoiceTitle
        description = $Texts[$Lang].InvoiceDesc
        payload = "private_channel_access_350"
        currency = "XTR"
        prices = @(
            @{ label = $Texts[$Lang].InvoiceLabel; amount = $PriceStars }
        )
    } | Out-Null

    SendText -ChatId $ChatId -Text $Texts[$Lang].PayText | Out-Null
}

function CreatePrivateInviteLink {
    $ExpireDate = [int][Math]::Floor(([DateTimeOffset](Get-Date).AddDays(1)).ToUnixTimeSeconds())
    $Result = TgPostJson -Method "createChatInviteLink" -Payload @{
        chat_id = $ChannelId
        member_limit = 1
        expire_date = $ExpireDate
    }
    $Result.result.invite_link
}

function SendJoinLink {
    param([long]$ChatId,[string]$Lang)
    $InviteLink = CreatePrivateInviteLink
    $Keyboard = @{
        inline_keyboard = @(
            @(@{ text = $Texts[$Lang].JoinBtn; url = $InviteLink })
        )
    }
    SendText -ChatId $ChatId -Text $Texts[$Lang].Paid -Keyboard $Keyboard | Out-Null
}

$Offset = 0
Write-Host "Bot avviato." -ForegroundColor Green

while ($true) {
    try {
        $Updates = Invoke-RestMethod -Uri "$Api/getUpdates?timeout=30&offset=$Offset" -Method Get

        foreach ($Update in $Updates.result) {
            $Offset = $Update.update_id + 1

            if ($null -ne $Update.message) {
                $ChatId = [long]$Update.message.chat.id
                $Text = [string]$Update.message.text

                if ($null -ne $Update.message.from) {
                    $UserNames[$ChatId] = GetDisplayName -User $Update.message.from
                }

                if ($Text -eq "/start") {
                    $UserLang[$ChatId] = "en"
                    $PreviewUsed[$ChatId] = $false
                    $Name = $UserNames[$ChatId]

                    SendText -ChatId $ChatId -Text "Hello $Name`n`n$($Texts["en"].WelcomeTitle)`n`n$($Texts["en"].WelcomeBody)" -Keyboard (GetLanguageKeyboard) | Out-Null
                }

                if ($null -ne $Update.message.successful_payment) {
                    $Payment = $Update.message.successful_payment

                    if ($Payment.invoice_payload -eq "private_channel_access_350") {
                        $Lang = if ($UserLang.ContainsKey($ChatId)) { $UserLang[$ChatId] } else { "en" }
                        SendJoinLink -ChatId $ChatId -Lang $Lang
                        SendText -ChatId $OwnerId -Text "Pagamento ricevuto da chat id $ChatId per accesso al canale privato." | Out-Null
                    }
                }
            }

            if ($null -ne $Update.pre_checkout_query) {
                $Pre = $Update.pre_checkout_query

                if ($Pre.invoice_payload -eq "private_channel_access_350") {
                    TgPostJson -Method "answerPreCheckoutQuery" -Payload @{
                        pre_checkout_query_id = $Pre.id
                        ok = $true
                    } | Out-Null
                }
            }

            if ($null -ne $Update.callback_query) {
                $Callback = $Update.callback_query
                $ChatId = [long]$Callback.message.chat.id
                $MessageId = [int]$Callback.message.message_id
                $Data = [string]$Callback.data

                if ($null -ne $Callback.from) {
                    $UserNames[$ChatId] = GetDisplayName -User $Callback.from
                }

                TgPostJson -Method "answerCallbackQuery" -Payload @{
                    callback_query_id = $Callback.id
                } | Out-Null

                $Lang = if ($UserLang.ContainsKey($ChatId)) { $UserLang[$ChatId] } else { "en" }
                $Name = if ($UserNames.ContainsKey($ChatId)) { $UserNames[$ChatId] } else { "friend" }

                if ($Data -eq "back_lang") {
                    EditText -ChatId $ChatId -MessageId $MessageId -Text "Hello $Name`n`n$($Texts["en"].WelcomeTitle)`n`n$($Texts["en"].WelcomeBody)" -Keyboard (GetLanguageKeyboard) | Out-Null
                    continue
                }

                if ($Data -like "lang_*") {
                    $Lang = $Data.Replace("lang_","")
                    $UserLang[$ChatId] = $Lang
                    EditText -ChatId $ChatId -MessageId $MessageId -Text "Hello $Name`n`n$($Texts[$Lang].WelcomeTitle)`n`n$($Texts[$Lang].MenuBody)" -Keyboard (GetMainKeyboard -Lang $Lang) | Out-Null
                    continue
                }

                if ($Data -eq "start_preview") {
                    if ($PreviewUsed.ContainsKey($ChatId) -and $PreviewUsed[$ChatId] -eq $true) {
                        SendText -ChatId $ChatId -Text $Texts[$Lang].PreviewUsed | Out-Null
                        continue
                    }

                    $PreviewUsed[$ChatId] = $true
                    SendText -ChatId $ChatId -Text $Texts[$Lang].Active | Out-Null
                    SendPreviewAlbumAsync -ChatId $ChatId -Lang $Lang -VideoIds $VideoIds -Token $Token
                    continue
                }

                if ($Data -eq "buy_access") {
                    try {
                        SendStarsInvoice -ChatId $ChatId -Lang $Lang
                    }
                    catch {
                        Write-Host "Errore invoice: $($_.Exception.Message)" -ForegroundColor Red
                        SendText -ChatId $ChatId -Text $Texts[$Lang].PayError | Out-Null
                    }
                    continue
                }
            }
        }
    }
    catch {
        Write-Host "Errore temporaneo: $($_.Exception.Message)" -ForegroundColor Yellow
        Start-Sleep -Seconds 2
    }
}
