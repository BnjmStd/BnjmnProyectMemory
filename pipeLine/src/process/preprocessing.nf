// java -jar /usr/share/java/trimmomatic-0.39.jar

process TRIMMO_PE {
    input:
    
    output:
    
    script:
    """
    
    """
}

process TRIMMO_SE {
    input:
    file k_fastq 

    script:
    """    
    java -jar /usr/share/java/trimmomatic-0.39.jar SE -phred33 $k_fastq platano_trimmed.fastq ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-SE.fa:2:30:10
    """

    output:
    file("platano_trimmed.fastq")
}

