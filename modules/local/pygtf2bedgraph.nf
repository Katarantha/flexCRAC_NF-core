process PYGTF2BEDGRAPH{
    tag "$meta.id"
    label 'process_high'

    input:
    tuple val(meta), path(mapped2), path(chromosome)
    
    output:
    tuple val(meta), path("*.bedgraph"), emit: bedgraph
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when
    
    script:
    """
    pyGTF2bedGraph.py --gtf '$mapped2' --count -v --permillion -o '${mapped2.baseName}' -c '$chromosome'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyGTF2bedGraph: \$( pyGTF2bedGraph.py --version)
    END_VERSIONS
    """

}