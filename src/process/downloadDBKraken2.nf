process DOWNLOAD_DECOMPRESS_DBKRAKEN2 {
    publishDir "${baseDir}/misc/db", mode:'move'
    
    input:
    val linkDescarga

    script:
    """
    # Descargar el archivo comprimido desde el enlace
    wget -O archivo_comprimido.tar.gz $linkDescarga
    
    mkdir db

    # Descomprimir el archivo
    tar -xzvf archivo_comprimido.tar.gz -C db
    """
}