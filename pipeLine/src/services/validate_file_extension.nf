// valida la extensión y compresión del archivo.
def validate_file(files) {
    def ext = file(files).extension ?: 'No tiene extensión'
    def isCompressed = ext in ['gz', 'zip', 'tar', 'bz2']

    if (isCompressed) {
        return [flag: true, ext: ext] as Tuple
    } else {
        println "El archivo no está comprimido"
        return [flag: false, ext: ext] as Tuple
    }
}