
workflow report_workflow {
    
    main:
    /*
    1. trimmo || spades || analisis
    2. spades ||análisis
    3. trimmo || spades
    4. trimmo ||
    5. análisis ||
    */


    /* Lo que haré es:  publishDir params.path, mode:'copy' en cada proceso final
        controlado 
    */

    // trimmomatic primero: publishDir 'reports/trimmo', mode: 'copy' 

}