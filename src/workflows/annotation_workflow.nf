include { BLASTN } from "${params.procces_in_workflow}/annotation.nf"
include { BLASTP } from "${params.procces_in_workflow}/annotation.nf"

workflow annotation_workflow {
    take:
    fasta
    fasta_ref

    main:
        BLASTN(fasta, file(fasta_ref))
}
