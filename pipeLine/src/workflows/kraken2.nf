/* Identificación Taxonómica */
include { KRAKEN2 } from '../process/Taxonomy.nf'

/* Flujo de trabajo para todos */
workflow kraken2_taxonomy {
    take:
    db
    file 

    main:
    KRAKEN2(db, file)
}