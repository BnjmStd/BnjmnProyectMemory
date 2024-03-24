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
    file 'output_forward_paired.fastq'
    file 'output_forward_unpaired.fastq'
    file 'output_reverse_paired.fastq'
    file 'output_reverse_unpaired.fastq'

    script:
    """
    java -jar /usr/share/java/trimmomatic-0.39.jar PE $phred -threads $threads -trimlog $trimlog -summary $summary $forward_fastq $reverse_fastq \\
        output_forward_paired.fastq output_forward_unpaired.fastq \\
        output_reverse_paired.fastq output_reverse_unpaired.fastq \\
        ILLUMINACLIP:$illuminaAdapter
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
    file "${k_fastq.baseName}"

    script:
    """    
    
    java -jar /usr/share/java/trimmomatic-0.39.jar SE $phred -threads $threads -trimlog $trimlog -summary $summary $k_fastq $k_fastq.baseName ILLUMINACLIP:$illuminaAdapter
    
    """
}

// java -jar /usr/share/java/trimmomatic-0.39.jar SE -phred33 $k_fastq $k_fastq.baseName ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-SE.fa:2:30:10





