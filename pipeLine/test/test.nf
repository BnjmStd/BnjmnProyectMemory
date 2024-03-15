// Lee el contenido del archivo JSON
def jsonContent = file("$projectDir/mocks/stages.json").text

// Parsea el contenido JSON con JsonSlurper
def jsonSlurper = new groovy.json.JsonSlurper()
def stagesAndPrograms = jsonSlurper.parseText(jsonContent)

// Imprime el resultado del parseo
println "Resultado del parseo del JSON:"
println stagesAndPrograms


// Define un proceso para cada etapa
stagesAndPrograms.stages.each { stage ->
    // Reemplaza espacios en el nombre de la etapa con guiones bajos
    def stageName = stage.name.replaceAll("\\s", "_")

    // Evalúa dinámicamente un bloque de código para cada etapa
    evaluate """
        process ${stageName} {
            // Imprime el nombre de la etapa
            script:
                println "Nombre de la etapa: ${stage.name}"

            // Define la entrada y salida según tu estructura de datos
            input:
                // Define la entrada según tu estructura de datos

            output:
                // Define la salida según tu estructura de datos

            script:
                // Define el script según tu estructura de datos
        }
    """
}

/*

params.qualityAssessment = false
params.annotation = false
params.argIdentifier = false



process qualityAssessment {
    input:
    
    output:
    
    script:
    """
    
    """
}

process annotation {
    input:
    
    output:
    
    script:
    """
    
    """
}

process argIdentifier {
    input:
    
    output:
    
    script:
    """
    
    """
}

            log.info """\
                P I P E L I N E -
                ===================================
                Validando InputFiles: ${params.files}
            """
            .stripIndent()


process assembly {
    input:
    
    output:
    
    script:
    """
    
    """
}

params.assembly = false
*/