def check_sra_id_services(id) {
    def pattern = ~/^[SED]RR\d{6,}$/
    
    if (id ==~ pattern) {
        return true
    } else {
        throw new Exception("Invalid SRA ID: $id")
    }
}