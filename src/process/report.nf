process REPORT_ENDING {
  publishDir 'report/', mode: 'copy'

  input:
  path value
  path direct 
  
  output:
  path "reporte_proyecto.pdf"
  
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
    texto <- paste(contenido, collapse = "\n")
    return(texto)
  })
  return(paginas)
}

# Crear el PDF con una portada y las páginas de los reportes
pdf("reporte_proyecto.pdf", width = 8.5, height = 11)
grid.text(frase_portada, x = 0.5, y = 0.5, gp = gpar(fontsize = 14, fontface = "bold"))  # Mantener la portada centrada
grid.newpage()  # Agregar un salto de página
for (archivo in archivos) {
  contenido <- crear_paginas(archivo)
  grid.text(contenido, x = 0.05, y = 0.5, just = "left")  # Cambiar la alineación del contenido a la izquierda
  grid.newpage()
}
dev.off()
        '
  """
}