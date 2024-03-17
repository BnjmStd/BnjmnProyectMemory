#!/usr/bin/env nextflow

/* params */
params.files = null   

/* process */ 
include { TRIMMO_SE } from './src/process/preprocessing.nf'
include { UNZIPFILE } from './src/process/decompress.nf'

/* services */
include { check_file } from './src/services/check_files_exist.nf'
include { validate_file } from './src/services/validate_file_extension.nf'

/* run docker compose -f docker-compose.yml run pipeline /bin/bash */
workflow {
    if (!check_file(params.files)) {
        throw new Error("Oops .. something went wrong uwu")
    }
    
    // file exist

    if (validate_file(params.files)['flag'][0] == true){
        if (validate_file(params.files)['ext'][0] == 'gz')
            UNZIPFILE(file(params.files))
        else {
            println ('formato de compresión no soportado')
        }
    } else {
        // no compress
        println ('partir flujo sin descomprimir.')
    }
}

workflow.onComplete {
    log.info ( workflow.success ? (
                "\nDone! --> $params.files\n"
            ) : (
                "Oops .. something went wrong uwu" 
            ) 
        )
}