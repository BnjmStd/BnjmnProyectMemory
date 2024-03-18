process UNZIPFILE {

    input:
    path file

    output:
    tuple val("$file.baseName"), file("$file")

    script:
    """
    archivo="$file"
    nombre_archivo=\$(basename "\$archivo")
    extension="\${nombre_archivo##*.}"

    # Verificar si el archivo está comprimido
    if [ "\$extension" == "gz" ]; then
        # Verificar si el archivo es un enlace simbólico
        if [ -L "\$archivo" ]; then
            # Obtener la ruta del archivo real
            archivo_real=\$(readlink -f "\$archivo")
            # Descomprimir el archivo real
            gunzip -c "\$archivo_real" > "\$archivo.baseName"
        else
            # Descomprimir el archivo directamente
            gunzip -c "\$archivo" > "\$archivo.baseName"
        fi
    else
        # Si el archivo no está comprimido, simplemente copiarlo
        cp "\$archivo" "\$archivo.baseName"
    fi
    """
}

