$Token = $env:TELEGRAM_BOT_TOKEN
if ([string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "ERRORE: variabile d'ambiente TELEGRAM_BOT_TOKEN non impostata." -ForegroundColor Red
    exit 1
}
$Api = "https://api.telegram.org/bot$Token"

$OwnerId = 8816533518
$ChannelId = "-1004496464649"
$PriceStars = 350
$PreviewSeconds = 30

$VideoIds = @(
    "BAACAgEAAxkBAAMEanXvgwUhWw_z1Aj04KoyiqXuonkAAkgIAAJJSrBHwjZ0ElIw9qg9BA",
    "BAACAgEAAxkBAAMGanXwThByLyuRaEAlFTrss9FPDDsAAkoIAAJJSrBHmkAdcyDjSYs9BA",
    "BAACAgEAAxkBAAMHanXwYf4b7BpkrSeRJCr3-KlL3U4AAksIAAJJSrBHsw74GRrMvLU9BA",
    "BAACAgEAAxkBAAMIanXwaCORE1OQsl23m3-zBkY3Ls8AAkwIAAJJSrBHTdlQRuVLmjc9BA",
    "BAACAgEAAxkBAAMJanXwm5_6iKsIO3TRVYbCUizVZq8AAk0IAAJJSrBHeUFFP1mUpUE9BA"
)

$Texts = @{
    Welcome      = [char]0x1F525 + " Welcome, {0}! You're about to see an exclusive free preview.`n`nThese clips are only available for the next $PreviewSeconds seconds " + [char]0x2014 + " watch closely " + [char]0x1F447
    Warning      = [char]0x231B + " 10 seconds left before this preview disappears forever..."
    Unlock       = "That was just a taste " + [char]0x1F60F + "`n`n" + [char]0x1F525 + " There's SO much more waiting for you inside the private channel " + [char]0x2014 + " way more videos, zero limits, no expiration.`n`n" + [char]0x1F449 + " Unlock everything right now before spots run out:"
    UnlockBtn    = [char]0x1F512 + " Unlock Full Access Now"
    InvoiceTitle = [char]0x1F512 + " Premium Channel Access"
    InvoiceDesc  = "Unlock full, unrestricted access to the exclusive content library. Limited spots available."
    InvoiceLabel = "Premium Channel Access"
    Paid         = [char]0x2705 + " Payment received! Your private access link is ready below."
    JoinBtn      = [char]0x1F517 + " Join private channel"
    PayError     = [char]0x274C + " Payment could not be opened right now."
    AlreadySeen  = [char]0x1F440 + " Welcome back, {0}! You've already seen the free preview.`n`n" + [char]0x1F525 + " Ready for the full experience? Way more content is waiting inside " + [char]0x2014 + " unlock it now " + [char]0x1F447
}

$PreviewUsed = @{}
$UserNames = @{}

function TgPostJson {
    param([string]$Method,[hashtable]$Payload)
    $Json = $Payload | ConvertTo-Json -Depth 20 -Compress
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Json)
    Invoke-RestMethod -Uri "$Api/$Method" -Method Post -ContentType "application/json; charset=utf-8" -Body $Bytes
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

function GetUnlockKeyboard {
    @{
        inline_keyboard = @(
            @(@{ text = $Texts.UnlockBtn; callback_data = "buy_access" })
        )
    }
}

function SendPreviewFlowAsync {
    param([long]$ChatId,[string]$Name,[string[]]$VideoIds,[string]$Token,[int]$PreviewSeconds)

    Start-Job -ScriptBlock {
        param($ChatId,$Name,$VideoIds,$Token,$PreviewSeconds,$Texts,$OwnerId)

        $Api = "https://api.telegram.org/bot$Token"

        function JobPost {
            param($Method,$Payload)
            $Json = $Payload | ConvertTo-Json -Depth 20 -Compress
            $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Json)
            Invoke-RestMethod -Uri "$Api/$Method" -Method Post -ContentType "application/json; charset=utf-8" -Body $Bytes
        }

        try {
            JobPost -Method "sendMessage" -Payload @{
                chat_id = $ChatId
                text = ($Texts.Welcome -f $Name)
            } | Out-Null

            $Media = @()
            foreach ($id in $VideoIds) { $Media += @{ type = "video"; media = $id } }

            $Album = JobPost -Method "sendMediaGroup" -Payload @{
                chat_id = $ChatId
                media = $Media
                protect_content = $true
            }

            $WarnDelay = [Math]::Max($PreviewSeconds - 10, 0)
            Start-Sleep -Seconds $WarnDelay

            JobPost -Method "sendMessage" -Payload @{ chat_id = $ChatId; text = $Texts.Warning } | Out-Null

            Start-Sleep -Seconds ([Math]::Min(10, $PreviewSeconds))

            foreach ($msg in $Album.result) {
                try {
                    JobPost -Method "deleteMessage" -Payload @{ chat_id = $ChatId; message_id = $msg.message_id } | Out-Null
                } catch {}
            }

            $Keyboard = @{
                inline_keyboard = @(
                    @(@{ text = $Texts.UnlockBtn; callback_data = "buy_access" })
                )
            }

            JobPost -Method "sendMessage" -Payload @{
                chat_id = $ChatId
                text = $Texts.Unlock
                reply_markup = $Keyboard
            } | Out-Null
        }
        catch {
            $ErrMsg = if ($_.ErrorDetails -and $_.ErrorDetails.Message) { $_.ErrorDetails.Message } else { $_.Exception.Message }
            try {
                JobPost -Method "sendMessage" -Payload @{
                    chat_id = $OwnerId
                    text = "Errore nell'invio preview a chat $ChatId : $ErrMsg"
                } | Out-Null
            } catch {}
        }
    } -ArgumentList $ChatId,$Name,$VideoIds,$Token,$PreviewSeconds,$Texts,$OwnerId | Out-Null
}

function SendStarsInvoice {
    param([long]$ChatId)
    TgPostJson -Method "sendInvoice" -Payload @{
        chat_id = $ChatId
        title = $Texts.InvoiceTitle
        description = $Texts.InvoiceDesc
        payload = "private_channel_access_350"
        currency = "XTR"
        prices = @(
            @{ label = $Texts.InvoiceLabel; amount = $PriceStars }
        )
    } | Out-Null
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
    param([long]$ChatId)
    $InviteLink = CreatePrivateInviteLink
    $Keyboard = @{
        inline_keyboard = @(
            @(@{ text = $Texts.JoinBtn; url = $InviteLink })
        )
    }
    SendText -ChatId $ChatId -Text $Texts.Paid -Keyboard $Keyboard | Out-Null
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
                $Name = if ($UserNames.ContainsKey($ChatId)) { $UserNames[$ChatId] } else { "friend" }

                if ($Text -eq "/start") {
                    if ($PreviewUsed.ContainsKey($ChatId) -and $PreviewUsed[$ChatId] -eq $true) {
                        SendText -ChatId $ChatId -Text ($Texts.AlreadySeen -f $Name) -Keyboard (GetUnlockKeyboard) | Out-Null
                    }
                    else {
                        $PreviewUsed[$ChatId] = $true
                        SendPreviewFlowAsync -ChatId $ChatId -Name $Name -VideoIds $VideoIds -Token $Token -PreviewSeconds $PreviewSeconds
                    }
                }

                if ($null -ne $Update.message.successful_payment) {
                    $Payment = $Update.message.successful_payment
                    if ($Payment.invoice_payload -eq "private_channel_access_350") {
                        SendJoinLink -ChatId $ChatId
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
                $Data = [string]$Callback.data

                TgPostJson -Method "answerCallbackQuery" -Payload @{
                    callback_query_id = $Callback.id
                } | Out-Null

                if ($Data -eq "buy_access") {
                    try {
                        SendStarsInvoice -ChatId $ChatId
                    }
                    catch {
                        $ErrMsg = if ($_.ErrorDetails -and $_.ErrorDetails.Message) { $_.ErrorDetails.Message } else { $_.Exception.Message }
                        Write-Host "Errore invoice: $ErrMsg" -ForegroundColor Red
                        SendText -ChatId $ChatId -Text $Texts.PayError | Out-Null
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
