
/* llamado de variantes */
include { VARIANT_CALLING } from '../process/variantCall.nf'
include { INDEX_GENOME_SAMTOOLS } from '../process/variantCall.nf'
include { DICT_SAMTOOLS } from '../process/variantCall.nf'
include { SAM_TO_BAM } from '../process/variantCall.nf'
include { DOWNLOADREF } from '../process/downloadRef.nf'

workflow variant_calling{
    take:
        fasta_ref
        emitt
    main:
        /* luego esto lo mando al gatk para el variant calling
            necesito el genoma ref, y el sam del alineamiento
            para que GATK funcione necesito generar el file .fai
        */
        result_FAI = INDEX_GENOME_SAMTOOLS(file(fasta_ref))
        result_Dict = DICT_SAMTOOLS(file(fasta_ref))
        /* El resultado del alineamiento me entrega un sam y al parecer GATK solo acepta BAM*/
        bam_alineamiento =  SAM_TO_BAM(emitt)
        resultVariantCalling = VARIANT_CALLING(file(params.variantRef), result_FAI ,result_Dict, bam_alineamiento)
}