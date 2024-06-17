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
        Rscript -e ""

  """
}