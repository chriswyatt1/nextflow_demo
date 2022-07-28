/*
 * pipeline input parameters
 */
params.reads = "$projectDir/data/ggal/gut_{1,2}.fq"
params.transcriptome_file = "$projectDir/data/ggal/transcriptome.fa"
params.multiqc = "$projectDir/multiqc"
params.outdir = "results"


log.info """\
    R N A S E Q - N F   P I P E L I N E   
    ===================================
    transcriptome: ${params.transcriptome_file}
    reads        : ${params.reads}
    outdir       : ${params.outdir}
    """
    .stripIndent()

include { INDEX } from './modules/index.nf'
include { QUANTIFICATION } from './modules/quantnf'
include { FASTQC } from './modules/fastqc.nf'
include { MULTIQC } from './modules/multiqc.nf'


workflow {

	transcript_ch = Channel.fromPath(params.transcriptome_file)

	index_ch = INDEX(transcript_ch)

	read_pairs_ch = Channel.fromFilePairs(params.reads)

	quant_ch = QUANTIFICATION(index_ch, read_pairs_ch)

    fastqc_ch = FASTQC(read_pairs_ch) 

    MULTIQC(quant_ch.mix(fastqc_ch).collect())
}

workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
