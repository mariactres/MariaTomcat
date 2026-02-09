#!/bin/bash

# ==============================================================================
# SCRIPT DE DESPLIEGUE AUTOMÁTICO - PROYECTO MARIATOMCAT
# ==============================================================================

# 1. CONFIGURACIÓN DE VARIABLES
REPO_ROOT="$HOME/MariaTomcat"
TOMCAT_WEBAPPS="/var/lib/tomcat10/webapps"
LIB_SERVLET="/usr/share/tomcat10/lib/servlet-api.jar"
WAR_NAME="MariaApp.war"
URL_APP="http://localhost:8080/MariaApp/hola"

echo ">>> Iniciando proceso de despliegue automático..."

# 2. ACTUALIZAR CÓDIGO DESDE GITHUB
echo "[1/6] Actualizando código desde el repositorio GitHub..."
cd $REPO_ROOT
git pull origin main
if [ $? -ne 0 ]; then
    echo "Error: No se pudo actualizar el código desde GitHub."
    exit 1
fi

# 3. COMPILAR EL SERVLET JAVA
echo "[2/6] Compilando HolaServlet.java..."
# Crear estructura de clases necesaria para el WAR
mkdir -p $REPO_ROOT/WEB-INF/classes
javac -cp "$LIB_SERVLET" $REPO_ROOT/src/HolaServlet.java -d $REPO_ROOT/WEB-INF/classes/

if [ $? -ne 0 ]; then
    echo "Error crítico: La compilación ha fallado."
    exit 1
fi

# 4. GENERAR EL ARCHIVO WAR
echo "[3/6] Generando archivo WAR de la aplicación..."
# Entramos a la raíz del repo para empaquetar index.html y WEB-INF
cd $REPO_ROOT
jar -cvf $WAR_NAME index.html WEB-INF/ > /dev/null

# 5. DESPLEGAR EL ARCHIVO WAR
echo "[4/6] Copiando el archivo WAR al directorio webapps de Tomcat..."
sudo cp $REPO_ROOT/$WAR_NAME $TOMCAT_WEBAPPS/

# 6. REINICIAR EL SERVICIO TOMCAT
echo "[5/6] Reiniciando el servicio Tomcat 10..."
sudo systemctl restart tomcat10

# 7. COMPROBACIÓN DE FUNCIONAMIENTO
echo "[6/6] Verificando respuesta de la aplicación..."
sleep 7 # Tiempo de espera para que Tomcat despliegue el WAR
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL_APP)

if [ "$STATUS" == "200" ]; then
    echo "===================================================="
    echo " ¡DESPLIEGUE COMPLETADO CON ÉXITO!"
    echo " URL pública: http://$(curl -s ifconfig.me):8080/MariaApp/hola"
    echo "===================================================="
else
    echo "Atención: La aplicación devolvió un código $STATUS."
    echo "Revisa los logs en /var/log/tomcat10/catalina.out"
fi
