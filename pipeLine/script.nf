#!/usr/bin/env nextflow

/* params */
params.trimmo = null
params.path = null
params.fastqc = null
params.spades = null

params.bowtie = null
params.bwa = null

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

    if (params.fastqc && params.trimmo == null && params.spades == null ) {
        FASTQC(files)
        .view { "result: ${it}" }
    } else if (params.fastqc && params.trimmo != null || params.fastqc && params.spades != null){
        throw new Error ('Sólo se puede ejecutar Fastqc')
    }

    if (params.trimmo) {
        files
        if (params.trimmo.toLowerCase() == 'se' ||  params.trimmo.toLowerCase() == 'pe') {
            // files.count().set { countFiles }
            if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'pe') {
                trimmo_result = TRIMMO_PE(files.collectFile(sort: true).collate(2), params.threads, params.phred, params.trimlog, params.summary, params.illuminaAdapter)
            } else if (cantidadArchivos % 2 != 0 && params.trimmo.toLowerCase() == 'pe') {
                throw new Error('La cantidad de archivos no facilita la creación de librerias')

            } else if (cantidadArchivos % 2 != 0 && params.trimmo.toLowerCase() == 'se') {
                trimmo_result = TRIMMO_SE(files, params.threads, params.phred, params.trimlog, params.summary, params.illuminaAdapter) // Generar SE impar
                
            } else if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'se') {
                trimmo_result = TRIMMO_SE(files, params.threads, params.phred, params.trimlog, params.summary, params.illuminaAdapter)
            } else {
                throw new Error('Something went wrong')
            }
        } else {
            throw new Error('El valor del parámetro "trimmo" debe ser "SE" o "PE"\n')
        }
    }

    if (params.spades) {
        if (params.trimmo.toLowerCase() == 'se' ||  params.trimmo.toLowerCase() == 'pe') {
            SPADES(trimmo_result.collect())
            .view { "result: ${ it }" }
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
// llamado de variante, análisis de ARG