process PYREADCOUNTERS{
    tag "$meta.id"
    label 'process_high'
    
    input:
    tuple val(meta), path(bam)
    path(gtf)

    output:
    tuple val(meta), path("*.gtf"), emit: mapped
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    pyReadCounters.py -f '$bam' --gtf '$gtf' -v --rpkm -o '${bam.baseName}' --file_type=sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyReadCounters: \$( pyReadCounters.py --version)
    END_VERSIONS
    """
} 