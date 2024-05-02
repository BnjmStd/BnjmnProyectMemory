#!/usr/bin/env nextflow

/* process */ 
include { DOWNLOAD_DECOMPRESS_DBKRAKEN2 } from "${params.process}/downloadDBKraken2.nf"
/* Evaluación de calidad */
include { TRIMMO_PE } from "${params.process}/preprocessing.nf"
include { TRIMMO_SE } from "${params.process}/preprocessing.nf"
include { UNZIPFILE } from "${params.process}/decompress.nf"
/* Ensamble y alineamiento */
include { SPADES_SE } from "${params.process}/assembly.nf"
include { SPADES_PE } from "${params.process}/assembly.nf"

/* Services */
include { check_directory_services } from "${params.services}/check_path_exist.nf"
include { count_files_services } from "${params.services}/check_count_files.nf"
include { validar_fasta_services } from "${params.services}/check_fasta.nf"
include { check_id_services } from "${params.services}/check_id.nf"
include { check_ilumina_clip_services } from "${params.services}/check_ilumina_clip.nf"
include { check_db_collection_services } from "${params.services}/check_db_download.nf"

/* Flujos de trabajo */
include { initial_download_workflow } from "${params.workflows}/initial_download_workflow.nf"
include { fastqc_review_workflow } from "${params.workflows}/fastqc_workflow.nf"
include { taxonomy_workflow } from "${params.workflows}/taxonomy_workflow.nf"
include { arg_workflow } from "${params.workflows}/arg_workflow.nf"
include { variant_calling_workflow } from "${params.workflows}/variant_calling_workflow.nf"
include { annotation_workflow } from "${params.workflows}/annotation_workflow.nf"
include { report_workflow } from "${params.workflows}/report_workflow.nf"

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
        check_directory_services(params.path)
        cantidadArchivos = count_files_services(params.path)

        /* sra toolkit */
        if (cantidadArchivos == 0 && params.id_sra == null) {
            throw new Error ('Faltan parámetros')
        } else if (cantidadArchivos == 0 && params.id_sra != null) {
            initial_download_workflow()
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
            fastqc_review_workflow(files, flag)
        }

    } else if (params.f != null && params.path == null) {
        validar_fasta_services(params.f)

    } else if (params.f != null && params.path != null) {
        throw new Error('Cant run --f and --path together')
    
    } else if (params.f == null && params.path == null) {
        if (params.dbdownload) {
            if (params.dbdownload == true) {
                throw new Error ('Database collection missing')
            } else {
                /* valido que la bd exista*/
                def x = check_db_collection_services(params.dbdownload)
                DOWNLOAD_DECOMPRESS_DBKRAKEN2(x)
            }
        } else {
            throw new Error('Important parameters are missing')
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
            check_ilumina_clip_services(params.illuminaAdapter)
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
                throw new Error('The number of files does not facilitate the creation of libraries')
            } else if (cantidadArchivos % 2 != 0 && params.trimmo.toLowerCase() == 'se') {
                
                trimmo_result = TRIMMO_SE(files, threads, phred, trimlog, summary, illuminaAdapter)

            } else if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'se') {
                trimmo_result = TRIMMO_SE(files, threads, phred, trimlog, summary, illuminaAdapter)
            } else {
                throw new Error('Something went wrong')
            }
        } else {
            throw new Error('The value of the "trimmo" parameter must be "SE" or "PE"\n')
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
        spades_result /* need it */
        if (params.variantRef) {
            // ok, valido la ref y ahora valido que es una ref (Fasta)
            validar_fasta_services(params.variantRef) 
            fasta = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
            variant_calling_workflow(params.variantRef, fasta)
            
        } else if ((params.variantRef == null) && (params.variantRefId != null)) {
            /* valido el id del genoma para proceder a descargar */
            check_id_services(params.variantRefId)
            /* ya que lo tengo descargo el genoma con R y rentrez*/
            ref =  DOWNLOADREF(params.variantRefId)
            fasta = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
            variant_calling_workflow(ref, fasta)
        } else {
            throw new Error('Enter a reference genome')
        }
    }

    /* identificación taxonómica */
    if ((params.taxonomy  != null) && (params.spades != null) && (flag == false)){
        /* proceso de kraken */
        if (!params.db) {
            throw new Error('database value is missing')
        }
        spades_result
        fasta = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
        /* TO DO: TENGO UN PROBLEMA CON LA RUTA, HAY QUE ENTREGARLE UNA ABSOLUTA*/
        check_directory_services(file(params.db))
        taxonomy_workflow(params.db, fasta)
    }
    
    /* anotación funcional */
    if ((params.annotation != null) && (params.spades != null) && (flag == false)) {
        spades_result  
        fasta = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
        annotation_workflow(fasta, params.variantRef)
    }

    /* Identificación de ARG */
    if ((params.arg != null) && (params.type != null) && (params.spades != null) && (flag == false)){
        spades_result
        fasta_ = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
        arg_workflow(params.organism, params.type, fasta_)
    } else if ( (params.arg != null) && (params.type == null) ) {
        throw new Error('The --type parameter is missing')
    }
    
    /* 
    ################################
    ################################
    ################################

    ~ Análisis con un fasta de entrada ~
    
    ################################
    ################################
    ################################
    */ 

    /* Identificación taxonomica */
    if (params.f != null && params.taxonomy != null && flag == false) {
        if (!params.db) {
            throw new Error('database value is missing')
        }

        /* TO DO: TENGO UN PROBLEMA CON LA RUTA, HAY QUE ENTREGARLE UNA ABSOLUTA */
        check_directory_services(file(params.db))
        taxonomy_workflow(params.db, file(params.f))
    }

    /* llamado de variantes */
    if ((params.f != null) && (params.variantCall != null) && (flag == false)) {
        if (params.variantRef) {
            // ok, valido la ref y ahora valido que es una ref (Fasta)
            validar_fasta_services(params.variantRef) 
            variant_calling_workflow(params.variantRef, params.f)
            
        } else if ((params.variantRef == null) && (params.variantRefId != null)) {
            /* valido el id del genoma para proceder a descargar */
            check_id_services(params.variantRefId)
            /* ya que lo tengo descargo el genoma con R y rentrez*/
            ref =  DOWNLOADREF(params.variantRefId)
            variant_calling_workflow(ref, params.f)
        }
    }
    
    /* ARG */
    if ((params.f != null) && (params.arg != null) && (params.type != null) && (flag == false)) {
        arg_workflow(params.organism, params.type, file(params.f))
    }

    /* anotación */
    if ((params.f != null) && (params.annotation != null) && (params.type != null) && (flag == false)) {
        annotation_workflow(params.f, params.f)
    }

    /* Reporte final */
    reporte_workflow()
}

workflow.onComplete {
    log.info ( workflow.success ? ("\ndone!\n") : ("Oops ..") )
}

/* phylogenetic 
include { phylogenetic_graph } from './src/workflows/phylogenetic.nf'

if ((params.phylogenetic != null) && (params.spades != null) && (flag == false)) {
    spades_result  
    fasta = spades_result.flatMap { it.listFiles() }.filter{ it.name == 'scaffolds.fasta' }
    phylogenetic_graph(fasta)
} 
*/