process PYGTF2SGR{
    tag "$meta.id"
    label 'process_high'

    input:
    tuple val(meta), path(mapped2), path(chromosome)

    output:
    tuple val(meta), path ("*.sgr") , emit: sgr
    path "versions.yml"             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    pyGTF2sgr.py --gtf '$mapped2' --zeros --count -v -o '${mapped2.baseName}' -c '$chromosome'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyGTF2sgr: \$( pyGTF2sgr.py --version)
    END_VERSIONS
    """

}