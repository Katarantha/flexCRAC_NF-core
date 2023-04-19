process PYFASTQDUPLICATEREMOVER{
    tag "$meta.id"
    label 'process_high'

    input:
    tuple val(meta), path(demultiplexed)

    output:
    tuple val(meta), path("flexbar_trimmed_*_collapsed.fasta"), emit: collapsed
    path "versions.yml"                                       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    pyFastqDuplicateRemover.py -f '$demultiplexed' -o '${demultiplexed.baseName}_collapsed.fasta'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyFastqDuplicateRemover: \$( pyFastqDuplicateRemover.py --version )
    END_VERSION
    """
} 