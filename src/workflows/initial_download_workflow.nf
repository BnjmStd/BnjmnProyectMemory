include { SRA_TOOLKIT_PAIRS } from "${params.procces_in_workflow}/get_sra.nf"
include { SRA_TOOLKIT } from "${params.procces_in_workflow}/get_sra.nf"

include { check_sra_id_services } from "${services_in_workflow}/check_sra_id.nf"

workflow initial_download_workflow {
    main:
        check_sra_id_services(params.id_sra)    
        if (params.pairs) {
            SRA_TOOLKIT_PAIRS(params.id_sra, params.x)
            .view { "Tus fq están aqui: ${it} y en --path"}
        } else {
            SRA_TOOLKIT(params.id_sra, params.x)
            .view { "Tu fq está aqui: ${it} y en --path" }
        }
}
