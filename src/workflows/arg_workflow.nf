/* Identificación de ARG */
include { AMRFINDER } from "${params.procces_in_workflow}/arg_process.nf"
include { AMRFINDER_ORGANISM } from "${params.procces_in_workflow}/arg_process.nf"

/* services */
include { check_organism_services } from "${params.services_in_workflow}/check_organism.nf"

workflow arg_workflow {
    take:
    organism
    type
    file

    main:
        if (organism != null ) {
            check_organism_services(organism)
            result_arg = AMRFINDER_ORGANISM("--organism ${organism}", type, file)
        }
        if ((type.toLowerCase() == 'p') || (type.toLowerCase() == 'n')) {
            if (organism == null) {
                result_arg = AMRFINDER(type, file)
            }
        } else {
            throw new Error('Params.type inválido')
        }
    emit:
    result_arg
}