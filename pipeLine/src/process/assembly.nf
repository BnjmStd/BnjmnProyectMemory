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
    spades.py -o output_spades -1 ${forward_reads} -2 ${reverse_reads} $phred_offset
    """
}