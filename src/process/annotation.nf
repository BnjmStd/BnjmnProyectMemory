
process BLASTN {
  input:
  path fasta
  path ref

  output:
  path "annotationN.txt"
  
  script:
  """
    makeblastdb -in $ref -dbtype nucl -out make_
    blastn -query $fasta -db make_ -outfmt 7 -out annotationN.txt
  """
}

process BLASTP {
  input:
  path fasta
  path ref

  output:
  path "annotationP.txt"
  
  script:
  """
    makeblastdb -in $ref -dbtype prot -out make_
    blastn -query $fasta -db make_ -outfmt 7 -out annotationP.txt
  """
}

process REPORT_ANNOTATION {
  publishDir 'report/', mode: 'copy'
  
  input:
  path directorio
  
  output:
  path "report_annotation.txt"

  script:
  """
    awk '!/^#/' $directorio > filtered_annotation.txt
    echo "Resumen GENERAL de anotaciones:" > report_annotation.txt
    echo "El número de anotaciones finales es de: \$(grep -c -v '^#' annotationN.txt)" >> report_annotation.txt
    cat filtered_annotation.txt >> report_annotation.txt
  """
}