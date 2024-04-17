// check file exist uwu
def check_file(files) {
    try {
        if (files) {
            if (files.toString()) {
                if (file(files).exists()) {
                    return true
                } else {
                    throw new FileNotFoundException("El archivo ${files} especificado no existe")
                }
            } else {
                throw new IllegalArgumentException('El parámetro no es una cadena')
            }
        } else {
            throw new IllegalArgumentException('No existe')
        }
    } catch (FileNotFoundException e) {
        throw new Error("${e.message}")
    } catch (IllegalArgumentException e) {
        throw new Error("${e.message}")
    }
    return false
}