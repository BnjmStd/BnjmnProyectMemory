process ALIGNMENT_AND_INDEX {
    input:
    path refgen
    path fasta

    output:
    path "aligned_reads.sam"

    script:
    """
    # Genera el índice de BWA
    bwa index $refgen

    # Realiza el alineamiento utilizando el índice y las lecturas
    bwa mem $refgen $fasta > aligned_reads.sam
    """
}

process SAM_TO_BAM {
    input:
    path sam
    
    output:
    path "output.bam"

    script:
    """
    samtools view -bS $sam > output.bam
    """
}

process VARIANT_CALLING {
    input:
    path fasta_file
    path aligned_reads

    output:
    path "variants.vcf"

    script:
    """
    samtools sort $aligned_reads -o mapa.bwa.sort.bam
    samtools index mapa.bwa.sort.bam
    samtools mpileup -g -f $fasta_file mapa.bwa.sort.bam > map.mpileup.bcf
    
    """
}

// freebayes -f $fasta_file $aligned_reads > variants.vcf

process PNG_VARIANT_CALLING {
  input:
  path vcf
  
  output:
  file 'output.png'
  
  script:

  """
    Rscript -e "library(vcfR);
                vcf_data <- read.vcfR('$vcf');
                vcf_matrix <- as.matrix(vcf_data@gt);
                png('output.png', width=800, height=600);
                heatmap(vcf_matrix);
                dev.off();"
  """
}