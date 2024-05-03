include { SAM_TO_BAM } from '../process/variantCall.nf'
include { BAM_TO_FASTA } from '../process/phylogenetic.nf'
include { PHYLOGENETIC } from '../process/phylogenetic.nf'


workflow  phylogenetic_graph {
    take:
    fasta

    main:
    PHYLOGENETIC(fasta)
}