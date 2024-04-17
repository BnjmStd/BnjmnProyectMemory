process INDEXGENOME {
    input:
    path refgen

    output:
    path "refgen_index" 

    script:
    """
    mkdir refgen_index
    bowtie2-build $refgen refgen_index/refgen
    """
}

process ALINEAMIENTO {
    input:
    path index_dir
    path spades_output    
    
    output:
    path "aligned_reads.sam"
    
    script:
    """
    bowtie2 -x $index_dir/refgen -f $spades_output/scaffolds.fasta -S aligned_reads.sam
    """
}

process INDEX_GENOME_SAMTOOLS {
    input:
    path genRef

    output:
    path "${genRef}.fai"

    script:
    """
    samtools faidx $genRef
    """
}

process DICT_SAMTOOLS {
    input:
    path genRef

    output:
    path "${genRef.baseName}.dict"

    script:
    """
    samtools dict $genRef > ${genRef.baseName}.dict
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
    path fai_file
    path dict_file
    path aligned_reads

    output:
    path "variants.vcf"
    
    script:
    """
    gatk --java-options "-Xmx4g" HaplotypeCaller -R $fasta_file -I $aligned_reads -O variants.vcf 
    """
}