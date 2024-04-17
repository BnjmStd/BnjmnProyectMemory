def checkIluminaClip(String clip) {
    def iluminaClips = [
        "TruSeq3-PE-2.fa",
        "TruSeq3-PE.fa",
        "TruSeq2-PE.fa",
        "NexteraPE-PE.fa",
        "TruSeq3-SE.fa",
        "NexteraPE-PE.fa"
    ]

    def parts = clip.split(':', 2)
    def clipName = parts[0]
    
    if (!iluminaClips.contains(clipName)) {
        throw new IllegalArgumentException("El iluminaclip '$clip' no está en la lista de iluminaclips conocidos.")
    }
    
    if (parts.size() == 2) {
        def params = parts[1].split(':')
        if (params.size() != 3) {
            throw new IllegalArgumentException("El iluminaclip '$clip' no tiene el formato esperado.")
        }
    }

    return true
}