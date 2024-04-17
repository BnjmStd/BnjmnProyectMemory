/* Identificación de ARG */
include { AMRFINDER } from '../process/amrfinder.nf'
include { AMRFINDER_ORGANISM } from '../process/amrfinder.nf'

/* services */
include { check_organism } from '../services/check_organism.nf'

workflow amrFinder_workflow{
    take:
    organism
    type
    file

    main:
        if (organism != null ) {
            check_organism(organism)
            AMRFINDER_ORGANISM("--organism ${organism}", type, file)
        }
        if ((type.toLowerCase() == 'p') || (type.toLowerCase() == 'n')) {
            if (organism == null) {
                AMRFINDER(type, file)
            }
        } else {
            throw new Error('Params.type inválido')
        }
}