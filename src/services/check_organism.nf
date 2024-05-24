def check_typearg_services(String database) {
    def db = [
       "resfinder",
       "argannot",
       "ecoli_vg",
       "megares",
       "card",
       "ncbi",
       "ecoh",
       "vfdb",
       "plasmidfinder"
    ]

    if (!db.contains(database)) {
        throw new Error("El organismo ${database} no es válido.")
    }

    return true
}