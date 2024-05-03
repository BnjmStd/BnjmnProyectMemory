include { VARIANT_CALLING } from "${params.procces_in_workflow}/variantCall.nf"
include { SAM_TO_BAM } from "${params.procces_in_workflow}/variantCall.nf"
include { DOWNLOADREF } from "${params.procces_in_workflow}/downloadRef.nf"
include { REPORT_VARIANT_CALLING } from "${params.procces_in_workflow}/variantCall.nf"
include { ALIGNMENT_AND_INDEX } from "${params.procces_in_workflow}/variantCall.nf"
include { FILTROS_SNP } from "${params.procces_in_workflow}/variantCall.nf"

workflow variant_calling_workflow {
    take:
        fasta_ref
        fasta
    main:
        result_alineamiento = ALIGNMENT_AND_INDEX(file(fasta_ref), fasta)
        bam_alineamiento =  SAM_TO_BAM(result_alineamiento)
        resultVariantCalling = VARIANT_CALLING(file(fasta_ref), bam_alineamiento)
        only_snp =  FILTROS_SNP(resultVariantCalling)
        png =  REPORT_VARIANT_CALLING(only_snp)
    emit:
    png
}