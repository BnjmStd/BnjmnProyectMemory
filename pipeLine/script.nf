#!/usr/bin/env nextflow

params.files = null
params.PREPROCESSING = false

// docker compose -f docker-compose.yml run pipeline /bin/bash

def validate_file() {
    ext = file(params.files).extension ?: 'No tiene extensión'
    isCompressed = ext in ['gz', 'zip', 'tar', 'bz2']

    if (isCompressed) {
        params.flag = true
        params.extension = ext
    } else {
        println "El archivo no está comprimido"
        // to do: Hacer validación.
    }
}

params.files ? (
    params.files instanceof String ? (
        file(params.files).exists() ? (
            validate_file() 
        ) : (
            error 'El archivo especificado no existe'
        )
    ) : (
        error 'El parámetro no es una cadena'
    )
) : (
    error 'Ingrese el parámetro --files'
)

process UNZIPFILE {
    input:

    file inputFile
    
    output:

    path "${inputFile.baseName}"

    script:

    """
    gunzip -c $inputFile > ${inputFile.baseName}
    """
}

// java -jar /usr/share/java/trimmomatic-0.39.jar
process PREPROCESSING {

    input:
    file k_fastq 

    script:
    """    
    java -jar /usr/share/java/trimmomatic-0.39.jar SE -phred33 SRR27371487.fastq platano_trimmed.fastq ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-SE.fa:2:30:10
    """

    output:
    file("platano_trimmed.fastq")

}

workflow {
    if (params.flag) {
        if (params.extension == 'gz') {
            result = UNZIPFILE(file(params.files))
            PREPROCESSING(result)
        } else {
            error 'Formato no válido. Se espera una extensión .gz.'
        }
    } else {
        println "Aquí pasará algo cuando no esté comprimido."
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