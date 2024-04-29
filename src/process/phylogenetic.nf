process PHYLOGENETIC {
    input:
    file fasta_file

    output:
    file "_arbol.png"

    script:
    """
    Rscript -e "
        # Cargar el paquete 'ape'
        library(ape)

        # Especificar la ruta al archivo FASTA
        fasta_file <- $fasta_file

        # Leer las secuencias desde el archivo FASTA
        sequences <- read.dna(fasta_file, format = "fasta")

        # Realizar el alineamiento utilizando MUSCLE
        alignment <- muscle(sequences)

        # Construir un árbol filogenético con el método Neighbor-Joining (NJ)
        tree <- nj(dist.dna(alignment))

        # Generar un archivo PNG del árbol filogenético
        png("arbol_filogenetico.png", width = 800, height = 600)
        plot(tree)
        dev.off()
        "
    """
}

process BAM_TO_FASTA {
  input:
  path bam_file

  output:
  path "fasta_file.fasta"

  script:
  """
    samtools fasta ${bam_file} > fasta_file.fasta
  """
}