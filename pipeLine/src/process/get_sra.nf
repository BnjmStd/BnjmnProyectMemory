process SRA_TOOLKIT_PAIRS {
    
    publishDir params.path, mode:'copy'
    
    input:
    path dic
    val srr
    val number

    output:
    path dic
    script:
    
    """
    fastq-dump -X $number --split-files $srr -o $dic
    """
}
// fastq

process SRA_TOOLKIT {
    publishDir params.path, mode:'copy'
    
    input:
    path dic
    val srr
    val number


    output:
    path dic

    script:
    """
    fastq-dump -I $srr -X $number -O $dic
    """
}