# nf-core/cracflexalign: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1.7dev - 26th April 2023

### `Added`
	cracflexalign.nf: Addition of channeling changes to accomodate reversions to STAR build/align modules and Bowtie2 Build/align modules

### `Fixed`
	conf/modules.conf: Updates to Star Align, MultiQC and DumpSoftwareVersions modules
	modules.json	 : Updates to Star Align, MultiQC and DumpSoftwareVersions modules
	modules/nf-core/bowtie2/align/main.nf: Reversion to changes to fit inline with NF-core modules
	modules/nf-core/bowtie2/build/main.nf: Reversion to changes to fit inline with NF-core modules
	modules/nf-core/custom/dumpsoftwareversions/main.nf: Updated to NF-core latest version
	modules/nf-core/custom/dumpsoftwareversions/templates/dumpsoftwareversions.py: Updated to NF-core latest version
	modules/nf-core/multiqc/main.nf: Updated to NF-core latest version
	modules/nf-core/star/align/main.nf: Updated to NF-core latest version
	modules/nf-core/star/align/meta.yml: Updated to NF-core latest version

## v0.1.6dev - 25th April 2023

### `Added`
	modules/nf-core/hisat2/extractsplicesites/: New Module addition to accomodate Hisat2 build and align
	modules.json							  : Addition of Hisat2 extractsplicesites module 

### `Fixed`
	README.md					  		: fixed typo in default command
	conf/modules.config			  		: Changes to Hisat2 Alignment process to use -f default argument
	modules/nf-core/fastqc/main.nf		: Reversion to changes to fit with NF-core modules
	modules/nf-core/hisat2/align/main.nf: Reversion to changes to fit with NF-core modules
	modules/nf-core/hisat2/build/main.nf: Reversion to changes to fit with NF-core modules
	modules/nf-core/star/align/main.nf	: Reversion to changes to fit with NF-core modules
	nextflow.config						: Changes to default hisat2 build memory allocation
	subworkflows/local/input_check.nf	: Moved read grouping to main workflow
	workflows/cracflexalign.nf			: Changes to Channeling and process inputs due to reversion to above modules

## v0.1.5dev - 24th April 2023

### `Fixed`
	modules/local/pyreadcounters/: Added publishing for hitmaps on both pyReadCounters processes

## v0.1.4dev - 24th April 2023

### `Added`
	CITATIONS.md	: Added citations for all used software and test dataset
	README.md		: Added Contributions, Example Commands and Pipeline Summary
	conf/base.config: Addition of new default parameters
	conf/test.config: Addition of paths to sample dataset
	docs/usage.md	: Addition of usage input parameters and example commands
	test/			: Addition of test dataset files for .gtf, .fasta and .fastq.gz files

### `Fixed`
	assets/samplesheet.csv: Changes to accomodate test dataset
	cracflexalign.nf	  : Changes to GTF file staging

## v0.1.3dev - 24th April 2023

### `Added`
	README.md: Addition of Pipeline Summary and Command Example

## v0.1.2dev - 24th April 2023

### `Added`
	cracflexalign.nf	: Addition of Hisat2 Aligner and index builder, formatting and commenting changes for readability
	nextflow.config		: Addition of sort_bam input parameter
	nextflow_schema.json: Addition of sort_bam as a valid inpout parameter

### `Fixed`
	modules/nf-core/bowtie2/align/main.nf: Changes to input staging and removal of meta variable to accomodate pipeline
	modules/nf-core/bowtie2/build/main.nf: Changes to input staging and removal of meta variable to accomodate pipeline

## v0.1.1dev - 24th April 2023

### `Added`
	cracflexalign.nf	: Addition of Hisat2 aligner and index builder functionality and channel changes to accomodate
	nextflow.config 	: Addition of hisat2_build_memory and save_unaligned parameters
	nextflow_schema.json: Addition of hisat2_build_memory and save_unaligned as valid parameters

### `Fixed`
	modules/local/pyfastqduplicateremover.nf: Bug fix - was previously outputing .fasta files, corrected to .fastq files
	modules/nf-core/hisat2/align/main.nf	: Changes to input staging to accomodate this pipeline, changes to run command to accomodate input files
	modules/nf-core/hisat2/build/main.nf	: Changes to inputs, script and run command due to lack of splice site and lack of exon generation	


## v0.1.0dev - 24th April 2023

### `Added`
	cracflexalign.nf: Addition of version checking for all processing within the pipeline

### `Fixed`
	modules/local/generatebarcodes.nf 			  		 : Bug Fixes to version emit
	modules/local/flexbar.nf 				  	  		 : Bug Fixes to version emit
	modules/local/pybarcodefilter.nf 			  		 : Bug Fixes to version emit
	modules/local/pycalculatechromosomelengths.nf		 : Bug Fixes to version emit
	modules/local/pyfastqduplicateremover.nf 	  		 : Bug Fixes to version emit	
	modules/local/pygtf2bedgraph.nf 			  		 : Bug Fixes to version emit
	modules/local/pygtf2sgr.nf 					  		 : Bug Fixes to version emit
	modules/local/pyreadcounters/pyreadcounters.nf 		 : Bug Fixes to version emit
	modules/local/pyreadcounters/secondpyreadcounters.nf : Bug Fixes to version emit
	subworkflows/local/barcode_list_generate.nf 		 : Bug Fixes to version emit

## v0.0.12dev - 22nd April 2023

### `Added`
	cracflexalign.nf: Addition of pyGTF2bedGraph functionality

### `Fixed`
	modules/local/pygtf2bedgraph.nf: Input staging changes to allow functionality in current pipeline

## v0.0.11dev - 22nd April 2023

### `Added`
	cracflexalign.nf: Addition of pyGTF2SGR module functionality

### `Fixed`
	modules/local/pygtf2sgr.nf: Input staging changes to allow functionality in current pipeline 
	modules/local/pycalculatechromosomelengths.nf: Formatting changes

## v0.0.10dev - 22nd April 2023

### `Added`
	cracflexalign.nf: Addition of pyCalculateChromosomeLength functionality in preperation for downstream processes

### `Fixed`
	modules/local/pycalculatechromosomelengths.nf: Bug Fixes to versioning 

## v0.0.9dev - 22nd April 2023

### `Added`
	cracflexalign.nf: Addition of pyReadCounters and SecondpyReadCounters functionality

### `Fixed`
	modules/local/pyreadcounters/pyreadcounters.nf	    : Changes to input staging
	modules/local/pyreadcounters/secondpyreadcounters.nf: Changes to input staging

## v0.0.8dev - 22nd April 2023

### `Added`
	cracflexalign.nf	: Added STAR ALIGN and GENOMEGENERATE fucntionality, Addition of channels and input staging      for Alignment steps
	main.nf				: Addition if GTF input parameter
	nextflow.config 	: Addition of parameters to accomodate inputs for STAR_GENERATE and STAR_ALIGN
	nextflow_schema.json: Addition of input parameter specifications mentioned for previous step

### `Fixed`
	assets/samplesheet.csv			  : Changes to file paths due to development server changes
	modules/nf-core/star/align/main.nf: Changes to input parameters to allow functionality in this pipeline

## v0.0.7dev - 19th April 2023

### `Added`
	cracflexalign.nf: Added PyFastqDuplicateRemover module to workflow 

### `Fixed`
	pyfastqduplicateremover.nf: Bug Fix to version output command

## v0.0.6dev - 18th April 2023

### `Added`
	flatMap Function: Processing of the output files from pyBarcodeFilter process to associate the correct meta ID to 
					  the corresponding fastq file and flattens them for downstream process functionality

## v0.0.5dev - 16th April 2023

### `Fixed`
	pybarcodefilter.nf module: Bug Fix to input error, now functional

## v0.0.4dev - 16th April 2023

### `Fixed`
	cracflexalign workflow: 	formatting and temporary shut down of versioning on Flexbar and pyBarcodeFilter
	input_check.nf subworkflow: addition of groupTuple() operator to handle one file with multiple sampleID's
	fastqc/main.nf module:		changes to input staging to allow functionality with previous changes
	pyBarcodefilter.nf module:	Bug Fix - still unresolved as of this version

## v0.0.3dev - 7th April 2023

### `Added`
	new feature: pyBarcodeFeature module inclusion in cracflexalign workflow
	new file: 	 addition of BarcodeFilter module and subworflow to parse barcode.list file from samplesheet

## v0.0.2dev - 3rd April 2023

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
