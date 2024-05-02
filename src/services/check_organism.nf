def check_organism_services(String organismo) {
    def organismos = [
        "Acinetobacter_baumannii",
        "Burkholderia_cepacia",
        "Burkholderia_pseudomallei",
        "Campylobacter",
        "Citrobacter_freundii",
        "Clostridioides_difficile",
        "Enterobacter_asburiae",
        "Enterobacter_cloacae",
        "Enterococcus_faecalis",
        "Enterococcus_faecium",
        "Escherichia",
        "Klebsiella_oxytoca",
        "Klebsiella_pneumoniae",
        "Neisseria_gonorrhoeae",
        "Neisseria_meningitidis",
        "Pseudomonas_aeruginosa",
        "Salmonella",
        "Serratia_marcescens",
        "Staphylococcus_aureus",
        "Staphylococcus_pseudintermedius",
        "Streptococcus_agalactiae",
        "Streptococcus_pneumoniae",
        "Streptococcus_pyogenes",
        "Vibrio_cholerae",
        "Vibrio_parahaemolyticus",
        "Vibrio_vulnificus"
    ]

    if (!organismos.contains(organismo)) {
        throw new Error("El organismo ${organismo} no es válido.")
    }
}