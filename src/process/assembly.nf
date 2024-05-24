process SPADES_SE {
    input:
    path index
    val phred 

    output:
    path "output_spades"

    script:
    """
    spades.py --careful -o output_spades -s $index $phred 
    """
}

process SPADES_PE {
    input:
    path forward_reads
    path reverse_reads
    val phred_offset

    output:
    path "output_spades"

    script:
    """
    spades.py --careful -o output_spades -1 ${forward_reads} -2 ${reverse_reads} $phred_offset
    """
}

process REPORT_SPADES {
  publishDir 'report/', mode: 'copy'

  input:
  path directorio

  output:
  path "report_spades.txt"

  script:
  """
    cat ${directorio}/params.txt <(echo) ${directorio}/warnings.log > report_spades.txt
  """
}