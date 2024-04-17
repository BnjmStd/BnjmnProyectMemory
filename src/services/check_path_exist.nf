def check_directory(path) {
    try {
        if (path) {
            if (path.toString() instanceof String) { // Verifica si path es una cadena
                def directory = new File(path.toString())
                if (directory.exists() && directory.isDirectory()) {
                    return true
                } else {
                    throw new FileNotFoundException("El directorio ${path} especificado no existe")
                }
            } else {
                throw new IllegalArgumentException('El parámetro --path no es una cadena')
            }
        } else {
            throw new IllegalArgumentException('Ingrese el parámetro --path')
        }
    } catch (FileNotFoundException e) {
        throw new Error("${e.message}")
    } catch (IllegalArgumentException e) {
        throw new Error("${e.message}")
    }
    return false
}
