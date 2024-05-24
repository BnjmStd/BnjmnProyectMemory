/* Identificación de ARG */
include { abricate } from "${params.procces_in_workflow}/arg_process.nf"

/* services */
include { check_typearg_services } from "${params.services_in_workflow}/check_organism.nf"

workflow arg_workflow {
    take:
    typedb
    file

    main:
        if (check_typearg_services(typedb)) {
            result_arg = abricate(typedb, file)
        } else {
            throw new Error('Params.typearg inválido')
        }
    emit:
    result_arg
}