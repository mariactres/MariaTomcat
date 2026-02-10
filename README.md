# MariaTomcat
# MariaTomcat – Despliegue automático de aplicación Java en Tomcat

## Descripción del proyecto

Este proyecto consiste en el despliegue de una aplicación Java basada en **Servlets** sobre un servidor de aplicaciones **Apache Tomcat 10**, instalado en una instancia **EC2 de AWS con Ubuntu Server**.

El objetivo principal es **automatizar el proceso de despliegue** mediante un script Bash (`deploy.sh`), de forma que el despliegue sea reproducible, controlado y repetible, evitando la realización manual de tareas como la compilación, empaquetado y despliegue de la aplicación.

---

## Estructura del proyecto

La estructura del repositorio es la siguiente:

MariaTomcat/
├── src/
│ └── hola/
│ └── Hello.java
├── script/
│ └── deploy.sh
├── WEB-INF/
│ └── web.xml
├── .gitignore
└── README.md

### Descripción de los directorios

- **src/**  
  Contiene el código fuente Java de la aplicación. En este proyecto incluye el servlet `Hello.java`.

- **script/**  
  Contiene los scripts de automatización. El archivo `deploy.sh` realiza el despliegue completo de la aplicación en Tomcat.

- **WEB-INF/**  
  Incluye el descriptor de despliegue `web.xml`, necesario para la configuración del servlet.

- **.gitignore**  
  Define los archivos y directorios que no deben subirse al repositorio, como archivos `.class`, `.war` y otros generados automáticamente.

- **README.md**  
  Documento descriptivo del proyecto y de su estructura.

---

## Script de despliegue automático

El script `deploy.sh` realiza las siguientes acciones:

1. Actualiza el código desde el repositorio GitHub.
2. Compila el código Java utilizando la librería `servlet-api` de Tomcat 10.
3. Genera el archivo WAR de la aplicación.
4. Copia el WAR al directorio `webapps` de Tomcat.
5. Reinicia el servicio Tomcat.
6. Comprueba que la aplicación responde correctamente tras el despliegue.

---

## Notas importantes

- El repositorio **no incluye** archivos generados tras la compilación (`.class`, `.war`).
- No se suben directorios propios del servidor como `webapps` o `logs`.
- Todos los artefactos de despliegue se generan dinámicamente mediante el script.

---

## María

Proyecto realizado como práctica de despliegue automático de aplicaciones Java en entornos cloud.
