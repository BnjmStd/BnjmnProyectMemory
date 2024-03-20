#!/usr/bin/env nextflow

/* params */
params.trimmo = null
params.path = null

/* process */ 
include { TRIMMO_SE } from './src/process/preprocessing.nf'
include { UNZIPFILE } from './src/process/decompress.nf'

/* services */
include { check_file } from './src/services/check_files_exist.nf'
include { check_directory } from './src/services/check_path_exist.nf'

/* run: docker compose -f docker-compose.yml run pipeline /bin/bash */

workflow {
    check_directory(params.path)

    def archivos = file(params.path).listFiles()
    
    Channel.of(archivos)
        .branch { archivo ->
            con_gz: archivo.name.endsWith('.gz')
            fastq: archivo.name.endsWith('.fastq') || archivo.name.endsWith('.fq')
            otro: true
        }
        .set { result }

    finalChannel = UNZIPFILE(result.con_gz)

    files = finalChannel.mix(result.fastq)
    
    num = files.count().view()

    if (params.trimmo) {
        
        if (params.trimmo == 'SE') {
            uwu = TRIMMO_SE(files)
            uwu.subscribe { println it }
        } else if (params.trimmo == 'PE') {
            if (num % 2 == 0) {
                print ('soy par')
            }
            else {
                throw new Error('La cantidad de archivos no facilita la creación de librerias')
            }
        } else {
            throw new Error('El valor del parámetro "trimmo" debe ser "SE" o "PE"')
        }
    }
}

workflow.onComplete {
    log.info ( workflow.success ? (
                "\nDone!\n"
            ) : (
                "Oops .. something went wrong uwu" 
            ) 
        )
}

// fastq trimmo spades -> llamado de variante, análisis de ARG




