def validar_fasta_services(String filePath) {
    def file = new File(filePath)
    def lines = file.readLines()

    // Verificar que el archivo tenga al menos una línea
    if (lines.isEmpty()) {
        throw new Error ('El archivo está vacío.')
    }

    // Verificar el formato del encabezado del FASTA
    if (!lines[0].startsWith(">")) {
        throw new Error ('El encabezado FASTA es inválido.')
    }

    return true
}