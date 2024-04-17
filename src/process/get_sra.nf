process SRA_TOOLKIT_PAIRS { 
    publishDir params.path, mode:'copy'
    
    input:
    val srr
    val number

    output:
    tuple path("${srr}_1.fastq"), path("${srr}_2.fastq")
    
    script:
    """
    fastq-dump -X $number --split-files $srr
    """
}

process SRA_TOOLKIT {
    publishDir params.path, mode:'copy'

    input:
    val srr
    val number

    output:
    path "${srr}.fastq"

    script:
    """
    fastq-dump -I $srr -X $number 
    """
}