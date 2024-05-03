include { REPORT_ENDING } from "${params.procces_in_workflow}/report.nf"

workflow report_workflow {
    
    main:
        REPORT_ENDING('report/')
}