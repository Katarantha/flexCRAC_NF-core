process GENERATE_BARCODES {
    tag "$samplesheet"
    label 'process_single'

    input:
    path samplesheet

    output:
    path '*.list', emit: barcodes

    // Put version functionality in when working or make it take the versioning from check_samplesheet (also Python)

    when:
    task.ext.when == null || task.ext.when

    script: // This script is bundled with the pipeline, in nf-core/cracflexalign/bin/
    """
    barcode_parser.py $samplesheet barcode.list
    """
}