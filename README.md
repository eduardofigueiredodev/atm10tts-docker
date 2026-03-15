# All The Mods 10 - Servidor Docker

Servidor Minecraft do modpack **All The Mods 10 (ATM10)** rodando em Docker. A imagem baixa automaticamente o server pack mais recente do CurseForge durante o build.

## Requisitos

- [Docker](https://docs.docker.com/get-docker/) e [Docker Compose](https://docs.docker.com/compose/install/)
- Uma chave de API do [CurseForge](https://console.curseforge.com/#/api-keys)

## Configuracao

### 1. Chave de API do CurseForge

Crie um arquivo `cf_api_key` na raiz do projeto contendo sua chave de API:

```bash
echo "SUA_CHAVE_AQUI" > cf_api_key
```

> **Importante:** Nunca compartilhe ou commite esse arquivo. Adicione `cf_api_key` ao seu `.gitignore`.

### 2. EULA do Minecraft

O arquivo `eula.txt` precisa existir com `eula=true` para o servidor iniciar. Ele e montado como bind mount no container:

```
eula=true
```

### 3. Build e Inicializacao

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
├── Dockerfile            # Imagem base com download automatico do server pack
├── docker-compose.yml    # Configuracao dos servicos, volumes e secrets
├── cf_api_key            # Chave de API do CurseForge (NAO commitar)
├── eula.txt              # Aceite da EULA do Minecraft (bind mount)
└── README.md
```

## Volumes

| Volume | Tipo | Descricao |
|--------|------|-----------|
| `server_data` | Named volume | Armazena todos os arquivos do servidor (mods, configs, world, etc.) |
| `./eula.txt` | Bind mount | Arquivo de aceite da EULA, acessivel localmente |

## Portas

| Porta | Descricao |
|-------|-----------|
| `25565` | Porta padrao do Minecraft (TCP) |

## Comandos Uteis

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

## Solucao de Problemas

| Problema | Solucao |
|----------|---------|
| Container nao inicia | Verifique se `eula.txt` existe com `eula=true` |
| Erro de API do CurseForge | Confirme que o arquivo `cf_api_key` existe e contem uma chave valida |
| Erro ao montar arquivo | Certifique-se de que o arquivo local existe antes de subir o container. Docker cria uma pasta se o arquivo nao existir |
