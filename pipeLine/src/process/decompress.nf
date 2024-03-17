
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