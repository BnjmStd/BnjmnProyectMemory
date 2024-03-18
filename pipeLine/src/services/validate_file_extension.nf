def validate_file(files) {
    def ext = file(files).extension ?: 'No tiene'
    def validExtensions = ['gz', 'fasta']

    if (ext in validExtensions) {
        return true
    } else {
        throw new Error("Error: La extensión del archivo no es válida")
        return false
    }
}
