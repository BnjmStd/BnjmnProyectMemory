process abricate {
    publishDir 'report/', mode: 'copy'
    
    input:
    val type
    path output_spades

    output:
    path "report_arg.txt"
    
    script:
    """
    abricate $output_spades --db $type --csv > report_arg.txt
    """
}