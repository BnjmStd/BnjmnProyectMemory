process DOWNLOADREF {
    input:
    val id

    output:
    file "${id}.fasta" 

    script:
    """
    Rscript -e "library(rentrez); dengueseq_fasta <- entrez_fetch(db = 'nucleotide', id = '${id}', rettype = 'fasta'); write(dengueseq_fasta, file = '${id}.fasta')"
    """
}