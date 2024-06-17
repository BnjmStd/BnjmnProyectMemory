# generate_report.R

library(rmarkdown)

# Directorio que contiene los archivos .txt
input_dir <- './report'

# Verificar que la carpeta existe y listar los archivos
if (dir.exists(input_dir)) {
  
  # Listar todos los archivos .txt en el directorio
  files <- list.files(input_dir, pattern = '\\.txt$', full.names = TRUE)
  
  # Verificar si se encontraron archivos .txt
  if (length(files) > 0) {
    
    # Crear archivo RMarkdown temporal
    output_rmd <- 'reporte_proyecto.Rmd'
    
    # Crear el archivo RMarkdown
    cat('# Reporte de Archivos de Texto\n', file = output_rmd)
    
    # Leer cada archivo y agregar su contenido al archivo RMarkdown
    for (file in files) {
      cat('\n\n', file = output_rmd, append = TRUE)
      cat(paste0('## ', basename(file), '\n'), file = output_rmd, append = TRUE)
      cat('```{r, results="asis"}\n', file = output_rmd, append = TRUE)
      cat(paste0('cat(paste(readLines(', shQuote(file), '), collapse = "\\n"))\n'), file = output_rmd, append = TRUE)
      cat('```\n', file = output_rmd, append = TRUE)
    }
    
    # Compilar el archivo RMarkdown a PDF
    render(output_rmd, output_format = 'pdf_document', output_file = 'reporte_proyecto.pdf')
    
  } else {
    message("No se encontraron archivos .txt en el directorio '", input_dir, "'.")
  }
  
} else {
  stop("El directorio '", input_dir, "' no existe.")
}