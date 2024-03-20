// java -jar /usr/share/java/trimmomatic-0.39.jar
/*
process TRIMMO_PE {
    input:
    tuple file(entrada1), file(entrada2) 

    output:
    file "${entrada1.basename}_archivo_salida.fastq" 

    script:
    """
    java -jar /usr/share/java/trimmomatic-0.39.jar PE -phred33 ${entrada1} ${entrada2} ${taskId}_archivo_salida.fastq ${entrada1.basename}_R1_paired.fastq ${taskId}_R1_unpaired.fastq ${taskId}_R2_paired.fastq ${taskId}_R2_unpaired.fastq ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-PE.fa:2:30:10
    """
}
*/

process TRIMMO_SE {
    input:
    path k_fastq 

    output:
    file "${k_fastq.baseName}"

    script:
    """    
    java -jar /usr/share/java/trimmomatic-0.39.jar SE -phred33 $k_fastq $k_fastq.baseName ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-SE.fa:2:30:10
    """
}

//summary siempre
// marcador si (flexible)

//spades




