#!/usr/bin/env nextflow


params.pacBio='s3://wgs.algae.mogene.rawdata/MOgenePacBioRuns/MOgene_Dist-ClientUser47-10_17_2017/MOgene_Dist-ClientUser47-10_17_2017-5_E01/m54151_171019_081931.subreads.bam'
params.shortReads1='s3://wgs.algae.illumina.rawdata/IlluminaAcceleratorMiSeqRuns_A/WGSalgae-53282244/CS002_CHK15_CS003_CHK17_gDNA_TruSeq_FASTQ_Generation_2017-11-24_02_29_45Z-62258745/CS003_L001-ds.52d6c1ee6b094d2683f687b90a0e7450/CHK17gDNA_S2_L001_R1_001.fastq.gz'
params.shortReads2='s3://wgs.algae.illumina.rawdata/IlluminaAcceleratorMiSeqRuns_A/WGSalgae-53282244/CS002_CHK15_CS003_CHK17_gDNA_TruSeq_FASTQ_Generation_2017-11-24_02_29_45Z-62258745/CS003_L001-ds.52d6c1ee6b094d2683f687b90a0e7450/CHK17gDNA_S2_L001_R2_001.fastq.gz'

pacBio_data = Channel.fromPath(params.pacBio)
sr1_data = Channel.fromPath(params.shortReads1)
sr2_data = Channel.fromPath(params.shortReads2)



process Fastq {

	input:
	path pbBam from pacBio_data
  
  output:
	file 'CHK17.fastq' into fastq
  
  """
  bamToFastq  -i $pbBam -fq CHK17.fastq
  """
}

process Lordec {

  memory '64G'

  input:
  path pbFastq from fastq
  path sr1 from sr1_data
  path sr2 from sr2_data
  
  output:
  file 'CHK17_LorDec.fasta' into lordec
  
  """
  lordec-correct -2 $sr1 $sr2 -k 19 -s 3 -i $pbFastq -o CHK17_LorDec.fasta
  """

}

