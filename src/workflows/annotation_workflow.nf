include { BLASTN } from "${params.procces_in_workflow}/annotation.nf"
include { BLASTP } from "${params.procces_in_workflow}/annotation.nf"
include { REPORT_ANNOTATION } from "${params.procces_in_workflow}/annotation.nf"

workflow annotation_workflow {
    take:
    
    fasta
    db
    type

    main:

        if ((type == 'prot')) {
            x = BLASTN(fasta, file(db))
            result_annotation = REPORT_ANNOTATION(x)
        } else if ((type == 'nucl')) {
            x = BLASTP(fasta, file(db))
            result_annotation = REPORT_ANNOTATION(x)
        } else {
            throw new Error ('~ error type')
        }
       
    emit:
    
    result_annotation
}
