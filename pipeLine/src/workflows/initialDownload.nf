/* Descarga inicial */
include { SRA_TOOLKIT_PAIRS } from '../process/get_sra.nf'
include { SRA_TOOLKIT } from '../process/get_sra.nf'

include { validateSRAId } from '../services/validateSRA_id.nf'

/* Flujo de trabajo para 
descargar archivos FASTQ */
workflow initialDownload {
    main:
        validateSRAId(params.id_sra)    
        if (params.pairs) {
            SRA_TOOLKIT_PAIRS(params.id_sra, params.x)
            .view { "Tus fq están aqui: ${it} y en --path"}
        } else {
            SRA_TOOLKIT(params.id_sra, params.x)
            .view { "Tu fq está aqui: ${it} y en --path" }
        }
}
