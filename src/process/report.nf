process REPORT_ENDING {
  input:
  path direct 
  
  output:
  
  script:
  """
        # Instalar las bibliotecas necesarias
        Rscript -e "install.packages(c('gridExtra', 'grid'), dependencies = TRUE)"

        # Ejecutar el script de R para generar el PDF
        Rscript -e '
        library(gridExtra)
        library(grid)

        # Frase para la portada
        frase_portada <- "Este es el reporte de mi proyecto"

        # Directorio donde se encuentran los reportes de los procesos
        directorio <- "${direct}"

        # Obtener la lista de archivos de texto en el directorio
        archivos <- list.files(directorio, pattern = ".txt", full.names = TRUE)

        # Crear una función para leer los archivos de texto y agregarlos a páginas separadas
        crear_paginas <- function(archivos) {
        paginas <- lapply(archivos, function(archivo) {
            contenido <- readLines(archivo)
            textGrob(paste(contenido, collapse = "\n"), gp = gpar(fontsize = 10))
        })
        return(paginas)
        }

        # Crear las páginas con los reportes de los procesos
        paginas_reportes <- crear_paginas(archivos)

        # Crear el PDF con una portada y las páginas de los reportes
        pdf("reporte_proyecto.pdf", width = 8.5, height = 11)
        grid.text(frase_portada, x = 0.5, y = 0.5, gp = gpar(fontsize = 14, fontface = "bold"))
        grid.newpage()
        grid.arrange(grobs = paginas_reportes, ncol = 1)
        dev.off()
        '
  """
}