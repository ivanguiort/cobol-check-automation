#!/bin/bash

# 1. Inicializar configuración local de Zowe
zowe config init --force

# 2. CREAR EL PERFIL DE CONEXIÓN REAL CON EL HOST Y PUERTO
# Aquí es donde ocurre la conexión mágica usando tus credenciales y servidor
zowe profiles create zosmf-profile perfil-github \
  --host "$ZOWE_HOST" \
  --port "$ZOWE_PORT" \
  --user "$ZOWE_USERNAME" \
  --pass "$ZOWE_PASSWORD" \
  --reject-unauthorized false \
  --overwrite

# 3. Decirle a Zowe que use esta conexión por defecto para los siguientes comandos
zowe profiles set zosmf-profile perfil-github

# 4. Convertir usuario a minúsculas para USS
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# 5. Comprobar si existe la carpeta (ahora sí sabe a qué Mainframe conectarse)
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Creando carpeta en el USS del Mainframe..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck"
fi

# 6. Subir el framework
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --recursive \
  --binary-files "cobol-check-0.2.9.jar"
