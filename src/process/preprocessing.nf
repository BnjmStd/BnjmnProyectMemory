process TRIMMO_PE {

    input:
    tuple path(forward_fastq), path(reverse_fastq)
    val threads
    val phred
    val trimlog
    val summary
    val illuminaAdapter
    val leading 
    val trailing 
    val slidingwindow 
    val minlen 

    output:
    path "output_dir_trimmomatic"

    script:
    """
    java -jar /usr/share/java/trimmomatic-0.39.jar PE $phred $threads $trimlog $summary $forward_fastq $reverse_fastq \\
        ${forward_fastq.baseName}_output_forward_paired.fastq ${forward_fastq.baseName}_output_forward_unpaired.fastq \\
        ${reverse_fastq.baseName}_output_reverse_paired.fastq ${reverse_fastq.baseName}_output_reverse_unpaired.fastq \\
        $illuminaAdapter $leading $trailing $slidingwindow $minlen

    cat ${forward_fastq.baseName}_output_forward_paired.fastq ${forward_fastq.baseName}_output_forward_unpaired.fastq > _output_forward.fastq
    cat ${reverse_fastq.baseName}_output_reverse_paired.fastq ${reverse_fastq.baseName}_output_reverse_unpaired.fastq > _output_reverse.fastq
    
    rm ${forward_fastq.baseName}_output_forward_paired.fastq ${forward_fastq.baseName}_output_forward_unpaired.fastq ${reverse_fastq.baseName}_output_reverse_paired.fastq ${reverse_fastq.baseName}_output_reverse_unpaired.fastq

    mkdir output_dir_trimmomatic
    mv _output_forward.fastq output_dir_trimmomatic/
    mv _output_reverse.fastq output_dir_trimmomatic/
    mv stats_summary.txt output_dir_trimmomatic/
    mv trim.log output_dir_trimmomatic/
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
    path "output_dir_trimmomatic"

    script:
    """    
    java -jar /usr/share/java/trimmomatic-0.39.jar SE $phred $threads $trimlog  $summary $k_fastq _log.fastq $illuminaAdapter
    
    mkdir output_dir_trimmomatic
    mv _log.fastq output_dir_trimmomatic/
    mv stats_summary.txt output_dir_trimmomatic/
    mv trim.log output_dir_trimmomatic/
    """
}

process REPORT_TRIMMOMATIC {
  publishDir 'report/', mode: 'copy'

  input:
  path directorio

  output:
  path "report_trimmomatic.txt"

  script:
  """
    cp ${directorio}/stats_summary.txt report_trimmomatic.txt
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
