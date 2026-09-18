#!/bin/bash

# 1. Configurar las variables de entorno dentro del sistema Unix del Mainframe (USS)
export PATH=$PATH:/usr/lpp/java/J8.0_64/bin
export JAVA_HOME=/usr/lpp/java/J8.0_64
export PATH=$PATH:/usr/lpp/zowe/cli/node/bin

# 2. Entrar a la carpeta donde subimos las cosas en el Paso 3
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
cd "/z/$LOWERCASE_USERNAME/cobolcheck"

# 3. Darle permisos de ejecución al framework en el entorno Unix
chmod +x cobolcheck
chmod +x scripts/linux_gnucobol_run_tests

# 4. Ejecutar cobol-check para el programa NUMBERS
# Esto lee el código COBOL y le inyecta las pruebas del archivo NUMBERS.cut
./cobolcheck -p NUMBERS

# 5. Si la herramienta generó con éxito el archivo fusionado (CC##99.CBL), 
# lo movemos desde el entorno Unix (USS) hacia los Datasets clásicos de MVS
if [ -f "CC##99.CBL" ]; then
  echo "CC##99.CBL generado. Copiando a Dataset MVS..."
  cp CC##99.CBL "//'${ZOWE_USERNAME}.CBL(NUMBERS)'"
else
  echo "ERROR: No se generó el archivo de pruebas CC##99.CBL"
  exit 1
fi

# 6. Copiar también el archivo JCL de control al Dataset correspondiente de MVS
if [ -f "NUMBERS.JCL" ]; then
  cp NUMBERS.JCL "//'${ZOWE_USERNAME}.JCL(NUMBERS)'"
fi
