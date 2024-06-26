include { FASTQC } from "${params.procces_in_workflow}/preprocessing.nf"

/* Flujo de trabajo para todos
los procesos de evaluación de calidad */
workflow fastqc_review_workflow {
    take:
    files
    flag

    main:
        if (params.fastqc && params.trimmo == null && params.spades == null && flag == true ) {
            FASTQC(files)
            .view { "result: ${it}" }
    
        } else if (params.fastqc && params.trimmo != null && params.fastqc && params.spades != null){
            throw new Error ('Sólo se puede ejecutar Fastqc')
        }
}