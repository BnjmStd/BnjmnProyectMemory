process UNZIPFILE {
    input:
    path file

    output:
    path "${file.baseName}"

    script:
    """
    archivo="$file"
    
    # Obtener el nombre base del archivo
    nombre_base=\$(basename "\$archivo" .gz)
    
    # Descomprimir el archivo
    gunzip -c "\$archivo" > "\$nombre_base"
    """
}