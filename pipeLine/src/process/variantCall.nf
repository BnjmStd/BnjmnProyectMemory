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

process ONE_DIRECTORY {
    input:
    path fai_file
    path fasta_file

    output:
    path "reference_files"

    script:
    """
    mkdir -p reference_files
    cp $fasta_file reference_files/
    cp $fai_file reference_files/
    """
}

process VARIANT_CALLING {
    input:
    path one
    path genRef
    path aligned_reads

    output:
    path "variants.vcf"
    
    script:
    """
    gatk --java-options "-Xmx4g" HaplotypeCaller -R $one/$genRef -D $one -I $aligned_reads -O variants.vcf
    """
}