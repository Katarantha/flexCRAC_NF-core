process FLEXBAR {
    tag "$meta.id"
    label 'process_medium'

    conda "conda-forge::flexbar=3.5.0--hf53871c_6"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/flexbar:3.5.0--hf53871c_6' :
        'quay.io/biocontainers/flexbar' }"

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