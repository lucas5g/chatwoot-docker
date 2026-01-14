FROM chatwoot/chatwoot:v4.9.2

# Instala Node.js, npm, pnpm e patch no Alpine
RUN apk add --no-cache nodejs npm patch && \
    npm install -g pnpm@10

# 0 - Atualiza a versão exibida no rodapé do Chatwoot
RUN sed -i '54i\      <span class="px-2">14/01/26</span>' app/javascript/dashboard/routes/dashboard/settings/account/components/BuildInfo.vue

# Copia os patches para o container
COPY patchs/ /tmp/patchs/

# Aplica todos os patches
RUN for patch_file in /tmp/patchs/*.patch; do \
      echo "Aplicando patch: $patch_file"; \
      patch -p1 < "$patch_file"; \
    done && \
    rm -rf /tmp/patchs

# Precompila os assets com uma SECRET_KEY_BASE fake
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile