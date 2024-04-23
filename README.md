# 🧬 Biotools 🧬
[![Version](https://img.shields.io/badge/Version-1.0.0-pink)](https://github.com/BnjmStd/BnjmnProyectMemory)
![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)
![Code Coverage](https://img.shields.io/badge/Coverage-95%25-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)

# Introducción

En respuesta a la creciente nececidad de simplificar el análisis de bacterias, se ha desarrollado un pipeline en NextFlow. Este facilita el análisis de resistencia antibióticos (ARG), llamada de variantes, identificación taxonomica y anotación funcional de bacterias noveles. El objetivo principal de este pipeline es proporcionar a los investigadores, incluso aquellos con conocimiento limitados en bioinformática, una herramienta accesible para explorar bacterias. 

El pipeline incluye la automatización de etapas claves como el procesamiento de datos crudos, como herramientas como trimmomatic, fastqc, el ensamblaje de genomas bacterianos utilizando SPAdes para un posterior análisis. Además, se ha diseñado un reporte completo que presenta de manera clara y concisa los resultados obtenidos, lo que permite una fácil interpretación.

![Texto alternativo](./misc/photos/Pipeline.png)

# Instalación y Configuración
### Uso:

1. Clona este repositorio

2. Instalar Docker Desktop

    Antes de usar este proyecto, asegúrate de tener Docker Desktop instalado en tu sistema. Puedes encontrar instrucciones detalladas sobre cómo instalar Docker Desktop en la documentación oficial de Docker: https://docs.docker.com/

3. Generar la imagen

    Para generar la imagen se recomienda el comando
    `
    docker-compose -f docker-compose.yml up --build 
    `
    
> [!WARNING]
> La imagen de Docker utilizada para construir el contenedor puede tener un tamaño más elevado de lo normal, lo que puede resultar en un tiempo de construcción prolongado. Estamos trabajando en optimizar esta imagen para reducir su tamaño y mejorar la eficiencia del proceso de construcción. Agradecemos tu paciencia mientras trabajamos en esta mejora.

> [!WARNING]
> Ten en cuenta que la imagen de Docker generada puede ocupar más espacio en disco de lo esperado. 

4. Ejecutar el contenedor

    Para ejecutar el contendor:
    `docker-compose docker-compose.yml run pipeline /bin/bash
    `

5. Antes de ejecutar el pipeline 

> [!IMPORTANT]
> Configurar el archivo [nextflow.config](./nextflow.config) con la cantidad de CPUS y MEMORY acorde a tus intereses.

> [!NOTE] 
> Si desea realizar la descarga de fastq a través del pípeline utilizando SRAtoolkit ejecute ``


En el caso de realizar un análisis de identificación taxonómica, es necesario la descarga previa de la base de datos de la web oficial de kraken2 https://benlangmead.github.io/aws-indexes/k2

> [!TIP]
> Si no desea descargar la base de datos manualmente, existe la funcionalidad de realizarla a través del pipeline con el comando --dbdownload [nombredeladb]. Los nombres de la base de datos disponibles para descargar se encuentran en [Nombres de bases de datos](./misc/dbnames.txt)

> [!CAUTION]
> Se debe escribir tal cual se encuentran las colecciones dentro del archivo en la ejecución del pipeline.

# Estructura del Pipeline:
## Descripción general de la estructura del pipeline.
## Explicación de los diferentes módulos o etapas del pipeline.
# Instrucciones de Uso:
## Guía detallada para ejecutar el pipeline.
## Comandos básicos para iniciar el pipeline.
## Ejemplos de uso con diferentes configuraciones o conjuntos de datos.

# Configuración Avanzada:
## Detalles sobre cómo personalizar la configuración del pipeline.
## Explicación de cómo modificar parámetros, cambiar flujos de trabajo o agregar nuevas funcionalidades.
# Dependencias y Requisitos:
## Lista de todas las dependencias y requisitos de software.

[Nombre del archivo](ruta/del/archivo)


## Detalles sobre las versiones específicas de las herramientas utilizadas.
# Solución de Problemas:
## Sección que aborda problemas comunes y sus soluciones.
## Preguntas frecuentes y posibles errores durante la ejecución.
# Contribuciones y Colaboración:
## Instrucciones para contribuir al desarrollo del pipeline.
## Detalles sobre cómo informar errores, enviar solicitudes de extracción, etc.
# Referencias y Recursos Adicionales:
# Licencia:
## Declaración de la licencia del pipeline y cualquier software de terceros utilizado.

## Parámetro 

## Estructura del proyecto

## Contribuir

## Licencia 

> [!NOTE] 
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.
