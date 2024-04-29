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
    path "variantes.vcf"

    script:
    """
    samtools sort $aligned_reads -o mapa.bwa.sort.bam
    samtools index mapa.bwa.sort.bam
    
   
    bcftools mpileup -Ou -f $fasta_file mapa.bwa.sort.bam | bcftools call -mv -Ov -o variantes.vcf

    """
}
//  bcftools mpileup -Ou -f $fasta_file mapa.bwa.sort.bam | bcftools call -mv -Ob -o variantes.bcf
// bcftools mpileup -g -f $fasta_file mapa.bwa.sort.bam > map.mpileup.bcf
// freebayes -f $fasta_file $aligned_reads > variants.vcf

process PNG_VARIANT_CALLING {
  input:
  path vcf
  
  output:
  file 'output.png'
  
  script:

  """
    Rscript -e "
            library(vcfR)

            # Lee el archivo VCF
            vcf_file <- '$vcf'
            vcf <- read.vcfR(vcf_file, verbose = FALSE)

            # Create a chromR object.
            chrom <- create.chromR(name="Supercontig", vcf=vcf, verbose=TRUE)
            "
  """
}