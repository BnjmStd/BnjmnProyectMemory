
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
  path directorio


  output:
  path "annotationP.txt"
  
  script:
  """
  cd $directorio
  blastp -query ../$fasta -db make_ -outfmt 7 -out annotationP.txt
  mv annotationP.txt ../
  """
}