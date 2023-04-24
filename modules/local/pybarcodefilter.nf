process PYBARCODEFILTER {
    tag "$meta.id"
    label 'process_high'

    input:
    path(barcodes)
    tuple val(meta), path(trimmed)
    

    output:
    tuple val(meta), path('flexbar_trimmed_*_*.fastq'), emit: demultiplexed
    path "versions.yml"                               , emit: versions   

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    pyBarcodeFilter.py -f $trimmed -b $barcodes -m 1

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyBarcodeFilter: \$( pyBarcodeFilter.py --version)
    END_VERSIONS
    """
    //run pyBarcode Filter on the trimmed reads from previous step using the barcodes provides with a maximum mismatch of 1 (this is the default)
} 