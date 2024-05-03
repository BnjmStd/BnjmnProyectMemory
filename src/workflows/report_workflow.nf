include { REPORT_ENDING } from "${params.procces_in_workflow}/report.nf"

workflow report_workflow {
    take:
    channel_report

    main:
        REPORT_ENDING(channel_report.collect(), "/workspace/report")
}