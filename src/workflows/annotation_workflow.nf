include { BLASTN } from "${params.procces_in_workflow}/annotation.nf"
include { BLASTP } from "${params.procces_in_workflow}/annotation.nf"
include { REPORT_ANNOTATION } from "${params.procces_in_workflow}/annotation.nf"

workflow annotation_workflow {
    take:
    fasta
    fasta_ref

    main:
        x = BLASTN(fasta, file(fasta_ref))
        result_annotation = REPORT_ANNOTATION(x)

    emit:
    result_annotation
}
