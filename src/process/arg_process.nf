process AMRFINDER {
    input:
    val type
    path output_spades

    output:
    path "amr_results.txt"
    
    script:
    """
    amrfinder "-$type" $output_spades > amr_results.txt
    """
}

process AMRFINDER_ORGANISM {
    input:
    val organism
    val type
    path output_spades

    output:
    path "amr_results.txt"
    
    script:
    """
    amrfinder $organism "-$type" $output_spades > amr_results.txt
    """
}