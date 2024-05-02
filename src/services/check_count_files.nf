def count_files_services(path) {
    def directorio = new File(path)
    def archivosQueCumplenCriterio = directorio.listFiles().findAll { archivo ->
        archivo.isFile() && (archivo.name.endsWith('.gz') || archivo.name.endsWith('.fastq') || archivo.name.endsWith('.fq'))
    }
    return archivosQueCumplenCriterio.size()
}