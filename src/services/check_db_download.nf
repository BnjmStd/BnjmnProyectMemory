def validarColeccion(String nombreColeccion) {
    def colecciones = [
        "Viral": "https://genome-idx.s3.amazonaws.com/kraken/k2_viral_20240112.tar.gz",
        "MinusB": "https://genome-idx.s3.amazonaws.com/kraken/k2_minusb_20240112.tar.gz",
        "Standard": "https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20240112.tar.gz",
        "Standard-8": "https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20240112.tar.gz",
        "Standard-16": "https://genome-idx.s3.amazonaws.com/kraken/k2_standard_16gb_20240112.tar.gz",
        "PlusPF": "https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_20240112.tar.gz",
        "PlusPF-8": "https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_08gb_20240112.tar.gz",
        "PlusPF-16": "https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_16gb_20240112.tar.gz",
        "PlusPFP": "https://genome-idx.s3.amazonaws.com/kraken/k2_pluspfp_20240112.tar.gz",
        "PlusPFP-8": "https://genome-idx.s3.amazonaws.com/kraken/k2_pluspfp_08gb_20240112.tar.gz",
        "PlusPFP-16": "https://genome-idx.s3.amazonaws.com/kraken/k2_pluspfp_16gb_20240112.tar.gz",
        "nt Database": "https://genome-idx.s3.amazonaws.com/kraken/k2_nt_20231129.tar.gz",
        "EuPathDB46": "https://genome-idx.s3.amazonaws.com/kraken/k2_eupathdb48_20230407.tar.gz"
    ]
    
    if (!colecciones.containsKey(nombreColeccion)) {
        throw new IllegalArgumentException("El nombre de la colección '$nombreColeccion' no existe.")
    }
    
    return colecciones[nombreColeccion]
}