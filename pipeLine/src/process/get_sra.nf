process SRA_TOOLKIT_PAIRS {
    input:
    
    output:
    
    script:
    """
    
    """
}

process SRA_TOOLKIT {
    input:
    val pathy
    val id_sra

    output:
    path pathy

    script:
    """
    fastq-dump -O $pathy $id_sra
    """
}