process SECONDPYREADCOUNTERS{
    tag "$meta.id"
    label 'process_high'
    
    input:
    tuple val(meta), path(gtf)
    each(bam)

    output:
    tuple val(meta), path('*.gtf'), emit: mapped2
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    pyReadCounters.py -f '$aligned_files' --gtf '$gtf' -v --rpkm -o '${aligned_files.baseName}_nomuts' --mutations  nomuts --blocks --file_type=sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyReadCounters: \$( pyReadCounters.py --version)
    END_VERSION
    """
} 