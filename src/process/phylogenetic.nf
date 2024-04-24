
process PHYLOGENETIC {
    input:
    path sam_file

    output:
    file "${sam_file.baseName}_arbol.png"

    script:
    """
    Rscript -e "
                # Leer datos de alineamiento en formato SAM
                alineamiento <- read.table('${sam_file}', sep='\t', header=FALSE, comment.char='');

                # Extraer las secuencias alineadas
                secuencias <- alineamiento\$V10;

                # Realizar el alineamiento con MUSCLE
                alineamiento_muscle <- msa(secuencias, method='Muscle');

                # Construir árbol filogenético con método de máxima verosimilitud
                arbol <- pml(alineamiento_muscle, model='HKY85');
                arbol_optimizado <- optim.pml(arbol);

                # Visualizar árbol filogenético
                png(filename='${sam_file.baseName}_arbol.png', width=800, height=600);
                plot(arbol_optimizado);
                dev.off();
                "
    """
}