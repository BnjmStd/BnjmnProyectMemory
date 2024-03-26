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
    path index


    output:
    path "output_spades"

    script:
    """
    spades.py -o output_spades --12 $index 
    
    """
}