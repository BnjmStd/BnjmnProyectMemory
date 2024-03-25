process SPADES {
    input:
    path index

    output:
    path "output"

    script:
    """
    spades.py -o output 
    
    """
}