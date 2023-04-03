# nf-core/cracflexalign: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.0.2dev - 3rd March 2023

### `Added`
	new file:   bin/barcode_parser.py - python script to generate barcode.list file from samplesheet
	new file:   modules/local/flexbar.nf - fix of v0.0.1 push error
	new file:   modules/local/generate_barcodes.nf - process to run the barcode_parser script
	new file:   modules/local/pybarcodefilter.nf - fix of v0.0.1 push error
	new file:   modules/local/pycalculatechromosomelengths.nf - fix of v0.0.1 push error
	new file:   modules/local/pyfastqduplicateremover.nf - fix of v0.0.1 push error
	new file:   modules/local/pygtf2bedgraph.nf - fix of v0.0.1 push error
	new file:   modules/local/pygtf2sgr.nf - fix of v0.0.1 push error
	new file:   modules/local/pyreadcounters/pyreadcounters.nf - fix of v0.0.1 push error
	new file:   modules/local/pyreadcounters/secondpyreadcounters.nf - fix of v0.0.1 push error
	new file:   modules/nf-core/bowtie2/align/main.nf - fix of v0.0.1 push error
	new file:   modules/nf-core/bowtie2/align/meta.yml - fix of v0.0.1 push error
	new file:   modules/nf-core/bowtie2/build/main.nf - fix of v0.0.1 push error
	new file:   modules/nf-core/bowtie2/build/meta.yml - fix of v0.0.1 push error
	new file:   modules/nf-core/hisat2/align/main.nf - fix of v0.0.1 push error
	new file:   modules/nf-core/hisat2/align/meta.yml - fix of v0.0.1 push error
	new file:   modules/nf-core/hisat2/build/main.nf - fix of v0.0.1 push error
	new file:   modules/nf-core/hisat2/build/meta.yml - fix of v0.0.1 push error
	new file:   modules/nf-core/star/align/main.nf - fix of v0.0.1 push error
	new file:   modules/nf-core/star/align/meta.yml - fix of v0.0.1 push error
	new file:   modules/nf-core/star/genomegenerate/main.nf - fix of v0.0.1 push error
	new file:   modules/nf-core/star/genomegenerate/meta.yml - fix of v0.0.1 push error
	new file:   subworkflows/local/barcode_list_generate.nf - subworkflow for the barcode generation package to mimic
                                                              input_check standard
### `Fixed`
    The above modules have now been correctly added to the Github Repository as they were not present in v0.0.1

    modified:   workflows/cracflexalign.nf - addition of barcode_list_generate function
    modified:   assets/samplesheet.csv - changes to a sample, barcode, fastq1 and fastq2 format
	modified:   assets/schema_input.json - allow for the additional input within the samplesheet



## v0.0.1dev - 27th March 2023

Initial release of nf-core/cracflexalign, created with the [nf-core](https://nf-co.re/) template.

### `Added`
 
CracFlexAlign.nf Workflow Changes
 - Addition of Valid Aligner Parameters star, hisat2 and bowtie2 to CracFlexAlign.nf
 - Staging of input files
 - Rudimentary chaining of processes in workflow step

NF-core Modules Added
 - Star Genome Generate
 - Star Align
 - Hisat2 Build
 - Hisat2 Align
 - Bowtie2 Build
 - Bowtie2 Align

Local Modules Built and Added
 - Flexbar - adapter trimming
 - pyBarcodeFilter - Demultiplexing of samples using sample barcodes
 - pyFastqDuplicateRemover - Collapsing of samples and removal of duplicates
 - pyCalculateChromosomeLength - generation of chromosome files from input fasta files for usage with further downstream processes in pyCrac Suite
 - pyReadCounters and pySecondReadCounters - Mapping of aligned reads to genome features with different options between first and second modules
 - pyGTF2sgr - generation of sgr readable files from output gtf files of pyReadCounters
 - pyGTF2bedgraph - generation of Bedgraph readable files from output gtf files of pyReadCounters

Samplesheet Changed
 - Addition of two new columns one for sample run name and one for the barcode

README Changes
 - Addition of customised introduction for this specific pipeline

Config Changes
 - Addition of Aligner parameters to allow for selection

NF_core Schema Changes
 - Addition of GTF input option under referene genome options
 - Addition of alignment options as valid command line parameters

Modules.json Changes
 - Addition of NF-core modules



### `Fixed`

### `Dependencies`

### `Deprecated`
