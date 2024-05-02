include { SAM_TO_BAM } from '../process/variantCall.nf'
include { BAM_TO_FASTA } from '../process/phylogenetic.nf'
include { PHYLOGENETIC } from '../process/phylogenetic.nf'


workflow  phylogenetic_graph {
    take:
    fasta

    main:

    /*
    
    result_alineamiento = alineamiento(fasta_ref, fasta)
    result_bam = SAM_TO_BAM(result_alineamiento)
    result_fasta = BAM_TO_FASTA(result_bam)
    
    */

    PHYLOGENETIC(fasta)
}