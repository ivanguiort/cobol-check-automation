#!/bin/bash

# 1. Forzar una inicialización limpia de perfiles locales de Zowe
zowe config init --force

# 2. Convertir tu usuario a minúsculas (requerido para las rutas de Unix en el Mainframe/USS)
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# 3. Comprobar si ya existe tu carpeta de pruebas en el Mainframe. Si no, crearla.
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "La carpeta no existe en el Mainframe. Creándola..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck"
else
  echo "La carpeta ya existe en el Mainframe."
fi

# 4. Subir la carpeta de cobol-check desde GitHub hacia el sistema Unix del Mainframe (USS)
# Indicamos que el archivo .jar se suba de forma binaria pura para que no se corrompa
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --recursive \
  --binary-files "cobol-check-0.2.9.jar"

# 5. Verificar visualmente en el log de GitHub que los archivos llegaron correctamente
echo "Verificando subida en el Mainframe:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
