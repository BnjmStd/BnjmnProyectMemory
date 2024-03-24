#!/usr/bin/env nextflow

/* params */
params.trimmo = null
params.path = null
params.fastqc = null
params.spades = null

/* params trimmomatic  */
params.threads = 1
params.phred = '-phred33'
params.trimlog = 'trim.log'
params.summary = 'stats_summary.txt'
params.illuminaAdapter = '/usr/share/trimmomatic/TruSeq3-SE.fa:2:30:10 '

/* params SPAdes */





/* process */ 
include { TRIMMO_PE } from './src/process/preprocessing.nf'
include { TRIMMO_SE } from './src/process/preprocessing.nf'
include { UNZIPFILE } from './src/process/decompress.nf'
include { FASTQC } from './src/process/preprocessing.nf'
include { SPADES } from './src/process/assembly.nf'

/* services */
include { check_file } from './src/services/check_files_exist.nf'
include { check_directory } from './src/services/check_path_exist.nf'
include { countFiles } from './src/services/countFiles.nf'

/* run: docker compose -f docker-compose.yml run pipeline /bin/bash */

workflow {

    check_directory(params.path)

    def cantidadArchivos = countFiles(params.path)
    
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

    if (params.fastqc) {
        FASTQC(files)
        .view { "result: ${it}" }
    }

    if (params.trimmo) {
        files
        if (params.trimmo.toLowerCase() == 'se' ||  params.trimmo.toLowerCase() == 'pe') {
            
            // files.count().set { countFiles }

            if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'pe') {
                files.groupTuple(2).set { 2blefile } // error
                TRIMMO_PE(2blefile, params.threads, params.phred, params.trimlog, params.summary, params.illuminaAdapter)

            } else if (cantidadArchivos % 2 != 0 && params.trimmo.toLowerCase() == 'pe') {
                throw new Error('La cantidad de archivos no facilita la creación de librerias')

            } else if (cantidadArchivos % 2 != 0 && params.trimmo.toLowerCase() == 'se') {
                TRIMMO_SE(files, params.threads, params.phred, params.trimlog, params.summary, params.illuminaAdapter) // Generar SE impar
                
            } else if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'se') {
                TRIMMO_SE(files, params.threads, params.phred, params.trimlog, params.summary, params.illuminaAdapter)
            } else {
                throw new Error('Something went wrong')
            }

        } else {
            throw new Error('El valor del parámetro "trimmo" debe ser "SE" o "PE"\n')
        }
    }

    if (params.spades) {

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