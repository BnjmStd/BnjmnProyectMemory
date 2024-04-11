process KRAKEN2 {
    input:
    path db
    path spades_output
    
    output:
    
    script:
    """
    kraken2 --db $db --report reporte.txt $spades_output/scaffolds.fasta
    """
}