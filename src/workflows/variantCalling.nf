include { VARIANT_CALLING } from '../process/variantCall.nf'
include { SAM_TO_BAM } from '../process/variantCall.nf'
include { DOWNLOADREF } from '../process/downloadRef.nf'
include { PNG_VARIANT_CALLING } from '../process/variantCall.nf'
include { ALIGNMENT_AND_INDEX } from '../process/variantCall.nf'

workflow variant_calling{
    take:
        fasta_ref
        fasta
    main:
        result_alineamiento = ALIGNMENT_AND_INDEX(file(fasta_ref), fasta)
        bam_alineamiento =  SAM_TO_BAM(result_alineamiento)
        resultVariantCalling = VARIANT_CALLING(file(fasta_ref), bam_alineamiento)
        png =  PNG_VARIANT_CALLING(resultVariantCalling)
}