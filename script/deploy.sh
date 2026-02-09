#!/bin/bash

set -e

REPO_ROOT="$HOME/MariaTomcat"
TOMCAT_WEBAPPS="/var/lib/tomcat10/webapps"
LIB_SERVLET="/usr/share/tomcat10/lib/servlet-api.jar"
WAR_NAME="MariaApp.war"
APP_NAME="MariaApp"
URL_APP="http://localhost:8080/MariaApp/hola"

echo ">>> Iniciando despliegue automático"

# 1. Actualizar código
echo "[1/6] Actualizando repositorio..."
cd "$REPO_ROOT"
git pull origin main

# 2. Limpiar compilación anterior
echo "[2/6] Limpiando compilación anterior..."
rm -rf WEB-INF/classes
mkdir -p WEB-INF/classes

# 3. Compilar Java
echo "[3/6] Compilando servlets..."
javac -cp "$LIB_SERVLET" \
$(find src -name "*.java") \
-d WEB-INF/classes

# 4. Crear WAR
echo "[4/6] Generando WAR..."
cd "$REPO_ROOT"
jar -cvf "$WAR_NAME" WEB-INF > /dev/null

# 5. Desplegar en Tomcat
echo "[5/6] Desplegando en Tomcat..."
sudo rm -rf "$TOMCAT_WEBAPPS/$APP_NAME"
sudo rm -f "$TOMCAT_WEBAPPS/$WAR_NAME"
sudo cp "$WAR_NAME" "$TOMCAT_WEBAPPS/"
sudo systemctl restart tomcat10

# 6. Verificación
echo "[6/6] Verificando aplicación..."
sleep 8
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL_APP")

if [ "$STATUS" = "200" ]; then
    echo "========================================"
    echo " DESPLIEGUE EXITOSO"
    echo " $URL_APP"
    echo "========================================"
else
    echo " Error HTTP $STATUS"
    echo " Revisa: /var/log/tomcat10/catalina.out"
fi
