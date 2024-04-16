def check_id(id) {
    if (id == true) {
        throw new Error("No se asigno un Id para descargar la ref")
    }
    
    def pattern = ~/NC_\d{6}/ // Expresión regular que busca "NC_" seguido de seis dígitos

    if (!id.matches(pattern)) {
        throw new Error("El ID ${id} no sigue el formato adecuado.")
    }
    return true
}
