/* llamado de variantes */
include { INDEXGENOME } from '../process/variantCall.nf'
include { ALINEAMIENTO } from '../process/variantCall.nf'

workflow alineamiento{
    take:
    fasta_ref
    fasta

    main:
        /* ahora que tengo la validación del fasta
        genero la indexcación del genoma para alinear
        debo pasarle el scaffold.fasta y el ref
        */
        index = INDEXGENOME(file(fasta_ref))
        result_alineamiento = ALINEAMIENTO(index, fasta) 

    emit:
    result_alineamiento
}