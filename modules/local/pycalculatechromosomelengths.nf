process CHROMOSOMELENGTH{
    tag "$meta.id"
    label 'process_high'

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("*.txt"), emit: chromosome
    path "version.yml"            , emit: version

    when:
    task.ext.when == null || task.ext.when
    
    script:
    """
    pyCalculateChromosomeLengths.py -f '$fasta' -o '${genome.baseName}_chromosome.txt' --file_type=fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyCalculateChromosomeLength.py: \$( pyCalculateChromosomeLengths.py --version)
    END_VERSION
    """
}