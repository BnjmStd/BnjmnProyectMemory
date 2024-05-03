process KRAKEN2 {
    publishDir 'report/', mode: 'copy'

    input:
    path db
    path spades_output
    
    output:
    path "report_taxonomy.txt"

    script:
    """
    kraken2 --db $db --report report_taxonomy.txt $spades_output 
    """
}