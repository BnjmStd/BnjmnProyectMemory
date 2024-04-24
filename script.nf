#!/usr/bin/env nextflow

/* params */
params.path = null
params.fastqc = null
params.spades = null
params.f = null
/* params sra toolkit */
params.id_sra = null
params.pairs = null 
params.x = 500
/* params trimmomatic  */
params.trimmo = null
params.threads = 1
params.phred = null
params.trimlog = null
params.summary = null
params.illuminaAdapter = null
params.leading = null
params.trailing = null
params.slidingwindow = null
params.minlen = null
/* params SPAdes */
params.phred_offset = ''
/* params Llamado de variante */
params.variantCall = null
params.variantRef = null
params.variantRefId = null
/* params para kraken2 */
params.kraken = null
params.db = null
/* amrFinder */
params.amrFinder = null
params.organism = null
params.type = null

/*  download kraken2db */
params.dbdownload = null

/* process */ 
include { DOWNLOAD_DECOMPRESS_DBKRAKEN2 } from './src/process/downloadDBKraken2.nf'
/* Evaluación de calidad */
include { TRIMMO_PE } from './src/process/preprocessing.nf'
include { TRIMMO_SE } from './src/process/preprocessing.nf'
include { UNZIPFILE } from './src/process/decompress.nf'
/* Ensamble y alineamiento */
include { SPADES_SE } from './src/process/assembly.nf'
include { SPADES_PE } from './src/process/assembly.nf'
/* llamado de variantes */
include { INDEXGENOME } from './src/process/variantCall.nf'
include { ALINEAMIENTO } from './src/process/variantCall.nf'
include { VARIANT_CALLING } from './src/process/variantCall.nf'
include { INDEX_GENOME_SAMTOOLS } from './src/process/variantCall.nf'
include { DICT_SAMTOOLS } from './src/process/variantCall.nf'
include { SAM_TO_BAM } from './src/process/variantCall.nf'
include { DOWNLOADREF } from './src/process/downloadRef.nf'

/* Services */
include { check_file } from './src/services/check_files_exist.nf'
include { check_directory } from './src/services/check_path_exist.nf'
include { countFiles } from './src/services/countFiles.nf'
include { validarFasta } from './src/services/validFasta.nf'
include { check_id } from './src/services/check_id.nf'
include { checkIluminaClip } from './src/services/check_iluminaClip.nf'
include { validarColeccion } from './src/services/check_db_download.nf'

/* Flujos de trabajo */
include { initialDownload } from './src/workflows/initialDownload.nf'
include { fastqc_review } from './src/workflows/fastqc.nf'
include { kraken2_taxonomy } from './src/workflows/kraken2.nf'
include { amrFinder_workflow } from './src/workflows/amrFinder.nf'

if(!nextflow.version.matches('>=23.0')) {
    println "This workflow requires Nextflow version 20.04 or greater and you are running version $nextflow.version"
    exit 1
}

def flag = false

if (params.fastqc) {
    flag = true
}

def cantidadArchivos = null

workflow {
    if (params.f == null && params.path != null) {
        check_directory(params.path)
        cantidadArchivos = countFiles(params.path)

        /* sra toolkit */
        if (cantidadArchivos == 0 && params.id_sra == null) {
            throw new Error ('Faltan parámetros')
        } else if (cantidadArchivos == 0 && params.id_sra != null) {
            initialDownload()
        } else if  (cantidadArchivos > 0 && params.id_sra != null) {
            throw new Error ('El directorio no está vacio ')
        } else if (cantidadArchivos > 0  && params.id_sra == null ) {

            /* Generación del canal de los archivos dentro del 
            directorio de trabajo */
            def archivos = file(params.path).listFiles()

            Channel.of(archivos)
                .branch { archivo ->
                    con_gz: archivo.name.endsWith('fastq.gz') || archivo.name.endsWith('fastq.gz')
                    fastq: archivo.name.endsWith('.fastq') || archivo.name.endsWith('.fq')
                    otro: true
                }
                .set { result }

            finalChannel = UNZIPFILE(result.con_gz)
            files = finalChannel.mix(result.fastq)
        }

        if (cantidadArchivos > 0 && params.fastqc != null) {
            fastqc_review(files, flag)
        }

    } else if (params.f != null && params.path == null) {
        validarFasta(params.f)

    } else if (params.f != null && params.path != null) {
        throw new Error('No se puede ejecutar --f y --path juntos')
    
    } else if (params.f == null && params.path == null) {
        if (params.dbdownload) {
            if (params.dbdownload == true) {
                throw new Error ('Falta colección')
            } else {
                /* valido que la bd exista*/
                def x = validarColeccion(params.dbdownload)
                DOWNLOAD_DECOMPRESS_DBKRAKEN2(x)
            }
        } else {
            throw new Error('Faltan parámetros importantes.')
        }
    }

    /* trimmomatic */
    if (params.trimmo && flag == false) {
        files

        def threads = params.threads ? "-threads ${params.threads}" : "-threads 1"
        def phred = params.phred ? "-${params.phred}" : '-phred33'
        def trimlog = params.trimlog ? "-trimlog ${params.trimlog}" : '-trimlog trim.log'
        def summary = params.summary ? "-summary ${params.summary}" : '-summary stats_summary.txt'
        def leading = params.leading ? "LEADING:${params.leading}" : ''
        def trailing = params.trailing ? "TRAILING:${params.trailing}" : ''
        def slidingwindow = params.slidingwindow ? "SLIDINGWINDOW:${params.slidingwindow}" : ''
        def minlen = params.minlen ? "MINLEN:${params.minlen}" : ''

        if (params.illuminaAdapter) {
            checkIluminaClip(params.illuminaAdapter)
        }

        def illuminaAdapter = params.illuminaAdapter ? "ILLUMINACLIP:/usr/share/trimmomatic/${params.illuminaAdapter}" : ''

        if (params.trimmo.toLowerCase() == 'se' ||  params.trimmo.toLowerCase() == 'pe') {
            if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'pe') {
                trimmo_result = TRIMMO_PE(files.collectFile().collate(2), threads, phred, trimlog, summary, illuminaAdapter, leading, trailing, slidingwindow, minlen, )

                trimmo_result.flatten().branch { archivo ->
                    forward: archivo.name.endsWith('_output_forward.fastq')
                    reverse: archivo.name.endsWith('_output_reverse.fastq')
                    otro: true
                }
                .set { archivos_separados }

            } else if (cantidadArchivos % 2 != 0 && params.trimmo.toLowerCase() == 'pe') {
                throw new Error('La cantidad de archivos no facilita la creación de librerias')
            } else if (cantidadArchivos % 2 != 0 && params.trimmo.toLowerCase() == 'se') {
                
                trimmo_result = TRIMMO_SE(files, threads, phred, trimlog, summary, illuminaAdapter)

            } else if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'se') {
                trimmo_result = TRIMMO_SE(files, threads, phred, trimlog, summary, illuminaAdapter)
            } else {
                throw new Error('Something went wrong')
            }
        } else {
            throw new Error('El valor del parámetro "trimmo" debe ser "SE" o "PE"\n')
        }
    }

    /* ensamble de novo */
    if (params.spades) {
        if (params.trimmo.toLowerCase() == 'pe') {
            archivos_separados
        }

        if (params.trimmo.toLowerCase() == 'se' ||  params.trimmo.toLowerCase() == 'pe') {
            
            if (params.trimmo.toLowerCase() == 'pe') {
                forw = archivos_separados.forward.map { it -> it.text }.collectFile(name: 'forward.fastq', newLine: true)
                revers = archivos_separados.reverse.map { it -> it.text }.collectFile(name: 'reverse.fastq', newLine: true)
                
                spades_result = SPADES_PE(forw, revers, params.phred_offset)

            } else if (params.trimmo.toLowerCase() == 'se') {
                unpaired = trimmo_result.map { it -> it.text }.collectFile(name: 'unpaired.fastq', newLine: true)
                
                spades_result = SPADES_SE(unpaired, params.phred_offset)
            } else {
                throw new Error ('something went wrong')
            }

        } else if (params.trimmo == null) {
            println ('hacer algo con params.path o files')
        
        } else {
            throw new Error ('something went wrong')
        }
    }

    /* variantCalling*/
    if ((params.variantCall != null) && (params.spades != null) && flag == false) {
        // ok si paso, valido la ref
        if (params.variantRef) {
            // ok, valido la ref y ahora valido que es una ref (Fasta)
            validarFasta(params.variantRef) 
            /* ahora que tengo la validación del fasta
            genero la indexcación del genoma para alinear
            debo pasarle el scaffold.fasta y el ref
            */
            index = INDEXGENOME(file(params.variantRef))

            spades_result /* need it */

            result_alineamiento = ALINEAMIENTO(index, spades_result) 
            /* luego esto lo mando al gatk para el variant calling
                necesito el genoma ref, y el sam del alineamiento
                para que GATK funcione necesito generar el file .fai
            */
            result_FAI = INDEX_GENOME_SAMTOOLS(file(params.variantRef))
            result_Dict = DICT_SAMTOOLS(file(params.variantRef))
            /* El resultado del alineamiento me entrega un sam y al parecer GATK solo acepta BAM*/
            bam_alineamiento =  SAM_TO_BAM(result_alineamiento)
            resultVariantCalling = VARIANT_CALLING(file(params.variantRef), result_FAI ,result_Dict, bam_alineamiento)

        } else if (params.variantRef == null && params.variantRefId != null) {
            /* valido el id del genoma para proceder a descargar */
            check_id(params.variantRefId)
            /* ya que lo tengo descargo el genoma con R y rentrez*/
            DOWNLOADREF(params.variantRefId)
        } else {
            throw new Error('Ingrese un genoma de ref ')
        }
    }

    /* identificación taxonómica */
    if ((params.kraken != null) && (params.spades != null) && (flag == false)){
        /* proceso de kraken */
        if (!params.db) {
            throw new Error('db no ingresada')
        }
        spades_result        
        fasta = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
        /* TO DO: TENGO UN PROBLEMA CON LA RUTA, HAY QUE ENTREGARLE UNA ABSOLUTA*/
        check_directory(file(params.db))
        kraken2_taxonomy(params.db, fasta)
    }

    /* Identificación de ARG */
    if ((params.amrFinder != null) && (params.type != null) && (params.spades != null) && (flag == false)){
        spades_result
        fasta_ = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
        amrFinder_workflow(params.organism, params.type, fasta_)
    } else if ( (params.amrFinder != null) && (params.type == null) ) {
        throw new Error('Falta ingresar el parámetro --type')
    }

    /* Análisis con un fasta de entrada */
    /*Identificación taxonomica*/
    if (params.f != null && params.kraken != null && flag == false) {
        if (!params.db) {
            throw new Error('db no ingresada')
        }

        /* TO DO: TENGO UN PROBLEMA CON LA RUTA, HAY QUE ENTREGARLE UNA ABSOLUTA*/
        check_directory(file(params.db))
        kraken2_taxonomy(params.db, file(params.f))
    }
    /* ARG */
    if ((params.f != null) && (params.amrFinder != null) && (params.type != null) && (flag == false)) {
        amrFinder_workflow(params.organism, params.type, file(params.f))
    }
    
    /* Llamado de variantes */
    /* anotación funcional */


    /* Reporte final */
}

workflow.onComplete {
    log.info ( workflow.success ? ("\nDone!\n") : ("Oops ..") )
}