#!/usr/bin/env nextflow

/* params */
params.files = null
params.trimmomatic = null

/* process */ 
include { TRIMMO_SE } from './src/process/preprocessing.nf'
include { UNZIPFILE } from './src/process/decompress.nf'

/* services */
include { check_file } from './src/services/check_files_exist.nf'
include { validate_file } from './src/services/validate_file_extension.nf'

/* run: docker compose -f docker-compose.yml run pipeline /bin/bash */

def filesList = params.files.split().collect { file(it) }
filesList.each { x -> 
    check_file(x) 
    validate_file(x)
}


workflow {
    Channel
        .from(filesList)
        .set { filesChannel }

    resultado_unCompress = UNZIPFILE(filesChannel)
    resultado_unCompress.view()
}


workflow.onComplete {
    log.info ( workflow.success ? (
                "\nDone! --> $params.files\n"
            ) : (
                "Oops .. something went wrong uwu" 
            ) 
        )
}