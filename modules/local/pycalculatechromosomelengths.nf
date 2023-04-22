process CHROMOSOMELENGTH{
    tag "$fasta.baseName"
    label 'process_single'

    input:
    path fasta 

    output:
    path '*.txt'                  , emit: chromosome
    path "versions.yml"            , emit: version

    when:
    task.ext.when == null || task.ext.when
    
    script:
    """
    pyCalculateChromosomeLengths.py -f '$fasta' -o '${fasta.baseName}_chromosome.txt' --file_type=fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyCalculateChromosomeLength: \$(pyCalculateChromosomeLengths.py --version)
    END_VERSIONS
    """
}