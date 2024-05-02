/* Identificación de ARG */
include { AMRFINDER } from '../process/arg_process.nf'
include { AMRFINDER_ORGANISM } from '../process/arg_process.nf'

/* services */
include { check_organism_services } from '../services/check_organism.nf'

workflow arg_workflow {
    take:
    organism
    type
    file

    main:
        if (organism != null ) {
            check_organism_services(organism)
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