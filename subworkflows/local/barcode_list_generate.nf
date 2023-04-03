//
// Take Samplesheet format and generate a barcode.list file for pyBarcodeFilter
//

include { GENERATE_BARCODES } from '../../modules/local/generate_barcodes'

workflow BARCODE_LIST {
    take:
    samplesheet

    main:
    GENERATE_BARCODES( samplesheet )
        .set{ barcodes }

    emit:
    barcodes

    //versioning (either add normal script or get this to take samplesheet checks version output and make it the version for this)
}