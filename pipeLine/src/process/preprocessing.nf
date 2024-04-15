// java -jar /usr/share/java/trimmomatic-0.39.jar
process TRIMMO_PE {
    input:
    tuple path(forward_fastq), path(reverse_fastq)
    val threads
    val phred
    val trimlog
    val summary
    val illuminaAdapter

    output:
    tuple path("${forward_fastq.baseName}_output_forward.fastq"), path("${reverse_fastq.baseName}_output_reverse.fastq")

    script:
    """
    java -jar /usr/share/java/trimmomatic-0.39.jar PE $phred -threads $threads -trimlog $trimlog -summary $summary $forward_fastq $reverse_fastq \\
        ${forward_fastq.baseName}_output_forward_paired.fastq ${forward_fastq.baseName}_output_forward_unpaired.fastq \\
        ${reverse_fastq.baseName}_output_reverse_paired.fastq ${reverse_fastq.baseName}_output_reverse_unpaired.fastq \\
        ILLUMINACLIP:$illuminaAdapter

    cat ${forward_fastq.baseName}_output_forward_paired.fastq ${forward_fastq.baseName}_output_forward_unpaired.fastq > ${forward_fastq.baseName}_output_forward.fastq
    cat ${reverse_fastq.baseName}_output_reverse_paired.fastq ${reverse_fastq.baseName}_output_reverse_unpaired.fastq > ${reverse_fastq.baseName}_output_reverse.fastq
    """
}

process TRIMMO_SE {
    input:
    path k_fastq
    val threads
    val phred 
    val trimlog 
    val summary 
    val illuminaAdapter 

    output:
    file "${k_fastq.baseName}_log.fastq"

    script:
    """    
    java -jar /usr/share/java/trimmomatic-0.39.jar SE $phred -threads $threads -trimlog $trimlog -summary $summary $k_fastq ${k_fastq.baseName}_log.fastq ILLUMINACLIP:$illuminaAdapter
    """
}

process FASTQC {
    input:
    path inputFile
    
    output:
    path "fastqc_${inputFile.baseName}_logs"
    
    script:
    """
    mkdir fastqc_${inputFile.baseName}_logs
    fastqc -o fastqc_${inputFile.baseName}_logs -f fastq -q $inputFile
    """
}
