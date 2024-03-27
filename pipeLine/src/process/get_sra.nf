process SRA_TOOLKIT_PAIRS {
    input:
    
    output:
    
    script:
    """
    fastq-dump -X 1000000 --split-files SRR390728
    """
}
// fastq

process SRA_TOOLKIT {
    publishDir params.path, mode:'copy'
    
    input:
    val pathy
    val id_sra

    output:
    path pathy

    script:
    """
    fastq-dump -O $pathy  -I $id_sra
    """
}