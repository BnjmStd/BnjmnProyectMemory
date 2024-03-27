def validateSRAId(id) {
    def pattern = ~/^[SED]RR\d{6,}$/
    
    if (id ==~ pattern) {
        return true
    } else {
        throw new Exception("Invalid SRA ID: $id")
    }
}