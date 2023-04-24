/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE INPUTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
def valid_params = [
    aligners    : ['star', 'hisat2', 'bowtie2']
]

def summary_params = NfcoreSchema.paramsSummaryMap(workflow, params)

// Validate input parameters
WorkflowCracflexalign.initialise(params, log)

// TODO nf-core: Add all file path parameters for the pipeline to the list below
// Check input path parameters to see if they exist
def checkPathParamList = [ params.input, params.multiqc_config, params.fasta ]
for (param in checkPathParamList) { if (param) { file(param, checkIfExists: true) } }

// Check mandatory parameters
if (params.input) { ch_input = file(params.input) } else { exit 1, 'Input samplesheet not specified!' }

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

ch_multiqc_config          = Channel.fromPath("$projectDir/assets/multiqc_config.yml", checkIfExists: true)
ch_multiqc_custom_config   = params.multiqc_config ? Channel.fromPath( params.multiqc_config, checkIfExists: true ) : Channel.empty()
ch_multiqc_logo            = params.multiqc_logo   ? Channel.fromPath( params.multiqc_logo, checkIfExists: true ) : Channel.empty()
ch_multiqc_custom_methods_description = params.multiqc_methods_description ? file(params.multiqc_methods_description, checkIfExists: true) : file("$projectDir/assets/methods_description_template.yml", checkIfExists: true)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//
include { INPUT_CHECK             } from '../subworkflows/local/input_check'
include { BARCODE_LIST_GENERATE   } from '../subworkflows/local/barcode_list_generate'
include { FLEXBAR                 } from '../modules/local/flexbar'
include { PYBARCODEFILTER         } from '../modules/local/pybarcodefilter'
include { PYFASTQDUPLICATEREMOVER } from '../modules/local/pyfastqduplicateremover'
include { PYREADCOUNTERS          } from '../modules/local/pyreadcounters/pyreadcounters'
include { SECONDPYREADCOUNTERS    } from '../modules/local/pyreadcounters/secondpyreadcounters'
include { PYGTF2SGR               } from '../modules/local/pygtf2sgr'
include { PYGTF2BEDGRAPH          } from '../modules/local/pygtf2bedgraph'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//
include { FASTQC                      } from '../modules/nf-core/fastqc/main'
include { MULTIQC                     } from '../modules/nf-core/multiqc/main'
include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/custom/dumpsoftwareversions/main'
include { STAR_GENOMEGENERATE         } from '../modules/nf-core/star/genomegenerate/main'
include { STAR_ALIGN                  } from '../modules/nf-core/star/align/main'     
include { HISAT2_BUILD                } from '../modules/nf-core/hisat2/build/main'
include { HISAT2_ALIGN                } from '../modules/nf-core/hisat2/align/main'
include { BOWTIE2_BUILD               } from '../modules/nf-core/bowtie2/build/main'
include { BOWTIE2_ALIGN               } from '../modules/nf-core/bowtie2/align/main'  
include { CHROMOSOMELENGTH            } from '../modules/local/pycalculatechromosomelengths'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Info required for completion email and summary
def multiqc_report = []

workflow CRACFLEXALIGN {

    ch_versions = Channel.empty()

    //
    // SUBWORKFLOW: Read in samplesheet, validate and stage input files
    //
    INPUT_CHECK (
        ch_input
    )
    ch_versions = ch_versions.mix(INPUT_CHECK.out.versions)

    //
    // SUWORKFLOW: read Samplesheet and generate a barcode.list file 
    //

    BARCODE_LIST_GENERATE (
        ch_input
    )
    ch_versions = ch_versions.mix(BARCODE_LIST_GENERATE.out.versions)

    //
    // MODULE: Run FastQC
    //

    FASTQC (
        INPUT_CHECK.out.reads
    )
    ch_versions = ch_versions.mix(FASTQC.out.versions.first())

    ch_fasta    = channel.fromPath(params.fasta, checkIfExists: true)

    //
    // MODULE: run STAR_GENOMEGENERATE: generation of alignement index for downstream STAR_ALIGN step
    //

    if (params.aligner == 'star'){
        STAR_GENOMEGENERATE( 
            ch_fasta, 
            params.gtf
        )
        ch_versions = ch_versions.mix(STAR_GENOMEGENERATE.out.versions.first())

        ch_index = STAR_GENOMEGENERATE.out.index
    }

        if (params.aligner == 'hisat2'){
        HISAT2_BUILD( 
            ch_fasta ,
            // params.gtf
        )
        ch_versions = ch_versions.mix(HISAT2_BUILD.out.versions.first())
        ch_index = HISAT2_BUILD.out.index
    }

    if (params.aligner == 'bowtie2'){
    BOWTIE2_BUILD( 
        ch_fasta
        )
        ch_versions = ch_versions.mix(BOWTIE2_BUILD.out.versions.first())
        ch_index = BOWTIE2_BUILD.out.index
    }

    //
    // MODULE: Run Flexbar - Adapter Trimming
    //

    FLEXBAR ( 
        INPUT_CHECK.out.reads
    ) 
    ch_versions = ch_versions.mix(FLEXBAR.out.versions)

    //
    // MODULE: Run pyBarcodeFilter - Demultiplex the Samples by barcode.list generated by BARCODE_GENERATE subworkflow
    //

    PYBARCODEFILTER (
        BARCODE_LIST_GENERATE.out.barcodes, FLEXBAR.out.trimmed
    )
    ch_versions = ch_versions.mix(PYBARCODEFILTER.out.versions)

    //
    // This block searches for the comman barcode string in both the meta ID and the fastq files produced by 
    // pyBarcodeFilter and associates the two corresponsing files in the respective lists for downstream processing
    //

    ch_id_pair = PYBARCODEFILTER.out.demultiplexed
    
    ch_id_paired = ch_id_pair.flatMap { meta_list, fastq_list ->
        def meta_map = meta_list.collectEntries { 
            meta ->  [ meta.id.split('_').first(), meta ]

        }
        def fastq_map = fastq_list.collectEntries { 
            fastq -> [ fastq.simpleName.split('_').last(), fastq ]

        }

        meta_map.collect { k, v -> [ v, fastq_map[k] ] }
    }

    // 
    // MODULE: Run PyFastqDuplicateRemover - Sample Collapse
    //

    PYFASTQDUPLICATEREMOVER(
        ch_id_paired
    )
    ch_versions = ch_versions.mix(PYFASTQDUPLICATEREMOVER.out.versions)

    ch_collapsed_out = PYFASTQDUPLICATEREMOVER.out.collapsed

    ch_aligner_input = ch_collapsed_out
                        .combine(ch_index)

    //
    // MODULE: run STAR_ALIGN: alignment of previously processed fastq files to index generated by STAR_GENOMEGENERATE
    //

    if (params.aligner == 'star'){
        STAR_ALIGN( 
            ch_aligner_input, 
            params.gtf,
            params.star_ignore_sjdbgtf,
            params.seq_platform,
            params.seq_center
        )
        ch_versions = ch_versions.mix(STAR_ALIGN.out.versions)

        ch_alignment_out = STAR_ALIGN.out.bam
    }

    if (params.aligner == 'hisat2'){
        HISAT2_ALIGN( 
            ch_aligner_input
        )
        ch_versions = ch_versions.mix(HISAT2_ALIGN.out.versions)

        ch_alignment_out = HISAT2_ALIGN.out.bam
    }

    if (params.aligner == 'bowtie2'){
        align_ch = BOWTIE2_ALIGN( 
            ch_aligner_input,
            params.save_unaligned,
            params.sort_bam
        )
        ch_versions = ch_versions.mix(BOWTIE2_ALIGN.out.versions)

        ch_alignment_out = BOWTIE2_ALIGN.out.bam
    }

    //
    // MODULE: run pyReadCounters on Aligned Reads to generate mapped gtf files
    //

    PYREADCOUNTERS(
        ch_alignment_out,
        params.gtf
    )
    ch_versions = ch_versions.mix(PYREADCOUNTERS.out.versions)

    //
    // MODULE: run pyReadCounters on Aligned Reads with different arguments
    //

    SECONDPYREADCOUNTERS(
        ch_alignment_out,
        params.gtf
    )
    ch_versions = ch_versions.mix(SECONDPYREADCOUNTERS.out.versions)
    ch_second_pyread_out = SECONDPYREADCOUNTERS.out.mapped2

    //
    // MODULE: run pyCalculateChromosomeLength to generate chromosome files for downstream use
    //

    CHROMOSOMELENGTH(
        ch_fasta
    )
    ch_versions = ch_versions.mix(CHROMOSOMELENGTH.out.versions)
    ch_chromosome = CHROMOSOMELENGTH.out.chromosome

    ch_post_align_input = ch_second_pyread_out 
                            .combine(ch_chromosome)

    //
    // MODULE: run pyGTF2sgr to generate sgr files from gtf files
    //

    PYGTF2SGR(
        ch_post_align_input
    )
    ch_versions = ch_versions.mix(PYGTF2SGR.out.versions)

    //
    // MODULE: run pyGTF2bedGraph to generate bedgraph files
    //

    PYGTF2BEDGRAPH(
        ch_post_align_input
    )
    ch_versions = ch_versions.mix(PYGTF2BEDGRAPH.out.versions)

    CUSTOM_DUMPSOFTWAREVERSIONS (
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )
    
    //
    // MODULE: MultiQC
    //

    workflow_summary    = WorkflowCracflexalign.paramsSummaryMultiqc(workflow, summary_params)
    ch_workflow_summary = Channel.value(workflow_summary)

    methods_description    = WorkflowCracflexalign.methodsDescriptionText(workflow, ch_multiqc_custom_methods_description)
    ch_methods_description = Channel.value(methods_description)

    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix(ch_workflow_summary.collectFile(name: 'workflow_summary_mqc.yaml'))
    ch_multiqc_files = ch_multiqc_files.mix(ch_methods_description.collectFile(name: 'methods_description_mqc.yaml'))
    ch_multiqc_files = ch_multiqc_files.mix(CUSTOM_DUMPSOFTWAREVERSIONS.out.mqc_yml.collect())
    ch_multiqc_files = ch_multiqc_files.mix(FASTQC.out.zip.collect{it[1]}.ifEmpty([]))

    MULTIQC (
        ch_multiqc_files.collect(),
        ch_multiqc_config.toList(),
        ch_multiqc_custom_config.toList(),
        ch_multiqc_logo.toList()
    )
    multiqc_report = MULTIQC.out.report.toList()

}



/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    COMPLETION EMAIL AND SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow.onComplete {
    if (params.email || params.email_on_fail) {
        NfcoreTemplate.email(workflow, params, summary_params, projectDir, log, multiqc_report)
    }
    NfcoreTemplate.summary(workflow, params, log)
    if (params.hook_url) {
        NfcoreTemplate.IM_notification(workflow, params, summary_params, projectDir, log)
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
