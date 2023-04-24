process FLEXBAR {
    tag "$meta.id"
    label 'process_high'

    input: 
    tuple val(meta), path(reads)

    output: 
    tuple val(meta), path('flexbar_trimmed.fastq'), emit: trimmed
    path "versions.yml"                           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    flexbar -r $reads -qf i1.8 -n 10 -ao 7 --output-reads flexbar_trimmed.fastq -qt 30

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        flexbar: \$( flexbar -version | sed -e 's/^.*flexbar version: //; s/SeqAn.*\$//')
        \$( flexbar -version | sed '2q;d'; -e 's/^.*SeqAn version: //' )
    END_VERSIONS
    """
} 