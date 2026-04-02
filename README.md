# All The Mods 10: To the Sky - Servidor Docker
Servidor Minecraft do modpack **All The Mods 10: To the Sky (ATM10SKY)** rodando em Docker. A imagem baixa automaticamente o server pack mais recente do CurseForge durante o build.
## Requisitos
- [Docker](https://docs.docker.com/get-docker/) e [Docker Compose](https://docs.docker.com/compose/install/)
- Uma chave de API do [CurseForge](https://console.curseforge.com/#/api-keys)
## Configuração
### 1. Chave de API do CurseForge
Crie um arquivo `cf_api_key` na raiz do projeto contendo sua chave de API:
```bash
echo "SUA_CHAVE_AQUI" > cf_api_key
```
> **Importante:** Nunca compartilhe ou commite esse arquivo. Adicione `cf_api_key` ao seu `.gitignore`.
### 2. EULA do Minecraft
O arquivo `eula.txt` precisa existir com `eula=true` para o servidor iniciar. Ele é montado como bind mount no container:
```
eula=true
```
### 3. Build e Inicialização
```bash
# Buildar a imagem (baixa o server pack do CurseForge)
docker compose build
# Iniciar o servidor
docker compose up -d
```
### 4. Acompanhar os Logs
```bash
docker compose logs -f
```
## Estrutura do Projeto
```
.
├── Dockerfile            # Imagem base com download automático do server pack
├── docker-compose.yml    # Configuração dos serviços, volumes e secrets
├── cf_api_key            # Chave de API do CurseForge (NÃO commitar)
├── eula.txt              # Aceite da EULA do Minecraft (bind mount)
└── README.md
```
## Volumes
| Volume | Tipo | Descrição |
|--------|------|-----------|
| `server_data` | Named volume | Armazena todos os arquivos do servidor (mods, configs, world, etc.) |
| `./eula.txt` | Bind mount | Arquivo de aceite da EULA, acessível localmente |
## Portas
| Porta | Descrição |
|-------|-----------|
| `25565` | Porta padrão do Minecraft (TCP) |
## Comandos Úteis
```bash
# Parar o servidor
docker compose down
# Parar e remover o volume (reset completo do servidor)
docker compose down -v
# Rebuildar a imagem (para atualizar o modpack)
docker compose build --no-cache
# Acessar o console do servidor
docker attach atm10tts
# Para sair do console sem parar o servidor: Ctrl+P, Ctrl+Q
```
## Solução de Problemas
| Problema | Solução |
|----------|---------|
| Container não inicia | Verifique se `eula.txt` existe com `eula=true` |
| Erro de API do CurseForge | Confirme que o arquivo `cf_api_key` existe e contém uma chave válida |
| Erro ao montar arquivo | Certifique-se de que o arquivo local existe antes de subir o container. Docker cria uma pasta se o arquivo não existir |
| `FILE_ID` nulo no build | A API do CurseForge não usa `isServerPack` — o server pack fica no campo `alternateFileId` do arquivo principal |
