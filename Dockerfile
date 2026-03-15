FROM eclipse-temurin:21-jre

RUN apt-get update && apt-get install -y wget unzip curl jq && apt-get clean

WORKDIR /server

ARG CF_PROJECT_ID=1298402

RUN --mount=type=secret,id=cf_api_key \
    CF_API_KEY=$(cat /run/secrets/cf_api_key) && \
    FILE_ID=$(curl -s -H "x-api-key: $CF_API_KEY" \
      "https://api.curseforge.com/v1/mods/${CF_PROJECT_ID}/files?pageSize=1&sortField=5&sortOrder=desc" \
      | jq -r '.data[0].serverPackFileId') && \
    URL=$(curl -s -H "x-api-key: $CF_API_KEY" \
      "https://api.curseforge.com/v1/mods/${CF_PROJECT_ID}/files/${FILE_ID}/download-url" \
      | jq -r '.data') && \
    wget -O serverpack.zip "$URL" && \
    unzip serverpack.zip && \
    rm serverpack.zip

COPY . .

RUN chmod +x startserver.sh

EXPOSE 25565

CMD ["./startserver.sh"]
