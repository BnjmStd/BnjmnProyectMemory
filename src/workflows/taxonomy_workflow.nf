/* Identificación Taxonómica */
include { KRAKEN2 } from "${params.procces_in_workflow}/Taxonomy.nf"

/* Flujo de trabajo para todos */
workflow taxonomy_workflow {
    take:
    db
    file 

    main:
    KRAKEN2(db, file)
}