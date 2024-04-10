#!/usr/bin/env nextflow

/* params */
params.trimmo = null
params.path = null
params.fastqc = null
params.spades = null

/* params sra toolkit */
params.id_sra = null
params.pairs = null 
params.x = 1000

/* params trimmomatic  */
params.threads = 1
params.phred = '-phred33'
params.trimlog = 'trim.log'
params.summary = 'stats_summary.txt'
params.illuminaAdapter = '/usr/share/trimmomatic/TruSeq3-SE.fa:2:30:10'

/* params SPAdes */
params.phred_offset = ''

/* params Llamado de variante */
params.variantCall = null
params.variantRef = null

/* process */ 

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
include { ONE_DIRECTORY } from './src/process/variantCall.nf'
/* Identificación Taxonómica */

/* Services */
include { check_file } from './src/services/check_files_exist.nf'
include { check_directory } from './src/services/check_path_exist.nf'
include { countFiles } from './src/services/countFiles.nf'
include { validarFasta } from './src/services/validFasta.nf'

/* Flujos de trabajo */
include { initialDownload } from './src/workflows/initialDownload.nf'
include { fastqc_review } from './src/workflows/fastqc.nf'

if( !nextflow.version.matches('>=23.0') ) {
    println "This workflow requires Nextflow version 20.04 or greater and you are running version $nextflow.version"
    exit 1
}

def flag = false

if (params.fastqc) {
    flag = true
}

    /*
        Llamado de variantes // necesito una ref bowtie 
        Asignación taxonómica
        Identificación ARg
        Análisis filogenético //  min 3 // 3 fasta // cual arbol, el genoma del organismo, un arbol de los genes o un arbol del proteoma , ¡genoma!
        
        Determinar incompatibilidad de plásmidos
    
    */

workflow {

    check_directory(params.path)
    def cantidadArchivos = countFiles(params.path)

    if (cantidadArchivos == 0 && params.id_sra == null) {
        throw new Error ('Faltan parámetros')
    } else if (cantidadArchivos == 0 && params.id_sra != null) {
        initialDownload()
    } else if  (cantidadArchivos > 0 && params.id_sra != null) {
        throw new Error ('El directorio no está vacio ')
    } else if (cantidadArchivos > 0  && params.id_sra == null) {

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

    fastqc_review(files, flag)

    if (params.trimmo && flag == false) {
        files
        if (params.trimmo.toLowerCase() == 'se' ||  params.trimmo.toLowerCase() == 'pe') {
            if (cantidadArchivos % 2 == 0 && params.trimmo.toLowerCase() == 'pe') {
                trimmo_result = TRIMMO_PE(files.collectFile().collate(2), params.threads, params.phred, params.trimlog, params.summary, params.illuminaAdapter)

                trimmo_result.flatten().branch { archivo ->
                    forward: archivo.name.endsWith('_output_forward.fastq')
                    reverse: archivo.name.endsWith('_output_reverse.fastq')
                    otro: true
                }
                .set { archivos_separados }

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

    /* bowtie2 and Gatk */

    /* variantCalling*/
    if ((params.variantCall != null) && (params.trimmo.toLowerCase() == 'se' || params.trimmo.toLowerCase() == 'pe') && flag == false) {
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
            one = ONE_DIRECTORY(result_FAI, file(params.variantRef))
            resultVariantCalling = VARIANT_CALLING(one, file(params.variantRef) ,result_alineamiento)
            resultVariantCalling.view { it }

        } else {
            throw new Error (' Ingrese un genoma de ref ')
        }
    }
}

/* identificación taxonómica */

workflow.onComplete {
    log.info ( workflow.success ? ("\nDone!\n") : ("Oops ..") )
}