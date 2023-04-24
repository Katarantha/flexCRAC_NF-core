//
// Take Samplesheet format and generate a barcode.list file for pyBarcodeFilter
//

include { GENERATE_BARCODES } from '../../modules/local/generatebarcodes'

workflow BARCODE_LIST_GENERATE {
    take:
    samplesheet

    main:
    GENERATE_BARCODES( samplesheet )
        
    emit:
    barcodes = GENERATE_BARCODES.out.barcodes
    versions = GENERATE_BARCODES.out.versions

    //versioning (either add normal script or get this to take samplesheet checks version output and make it the version for this)
}