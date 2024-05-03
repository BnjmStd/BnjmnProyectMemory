process AMRFINDER {
    publishDir 'report/', mode: 'copy'
    
    input:
    val type
    path output_spades

    output:
    path "report_arg.txt"
    
    script:
    """
    amrfinder "-$type" $output_spades > report_arg.txt
    """
}

process AMRFINDER_ORGANISM {
    publishDir 'report/', mode: 'copy'

    input:
    val organism
    val type
    path output_spades

    output:
    path "report_arg.txt"
    
    script:
    """
    amrfinder $organism "-$type" $output_spades > report_arg.txt
    """
}