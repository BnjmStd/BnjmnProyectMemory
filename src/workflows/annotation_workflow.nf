include { BLASTN } from '../process/annotation.nf'
include { BLASTP } from '../process/annotation.nf'

workflow annotation_workflow {
    take:
    fasta
    fasta_ref

    main:
        BLASTN(fasta, file(fasta_ref))
}
