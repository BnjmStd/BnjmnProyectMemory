#!/usr/bin/env nextflow

// Definir parámetros
params.report = params.report ?: null

process REPORT_ENDING {
    publishDir 'report/', mode: 'copy'

    input:
    path direct

    output:
    path "reporte_proyecto.pdf"

    script:
    """
    # Ejecutar el script R proporcionado por el usuario
    Rscript $direct
    """
}

// Flujo de trabajo principal
workflow {
    // Comprobar si params.report no es nulo y llamar a REPORT_ENDING
    if (params.report != null) {
        REPORT_ENDING(file(params.report))
    }
}