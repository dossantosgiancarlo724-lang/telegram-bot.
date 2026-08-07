FROM mcr.microsoft.com/powershell:latest

WORKDIR /app
COPY bot.ps1 .

CMD ["pwsh", "-File", "bot.ps1"]
