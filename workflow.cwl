cwlVersion: v1.0
class: Workflow
inputs:
  fastq: 
    type: File
    doc: |
      Fastq file

  genome1_fasta: 
    type: File
    doc: |
      Strain1_Fasta file

  saifile:
    type: string
    doc: |
      Sai output prefix with .sai
  
  threads: 
    type: int?
    doc: |
     Threads for bwa-align default is 0
  
  output_sam:
    type: string
    doc: |
      Final sam_file with .sam

outputs:
  output_sam:
    type: File
    outputSource: bwa_samse/output

steps:
  bwa-align:
    run: bwa-align.cwl
    in:
      prefix: genome1_fasta
      input: fastq
      output_file_name: saifile
      threads: threads
    out: [output]

  bwa_samse:
    run: bwa-samse.cwl
    in:
      fasta: genome1_fasta
      input_sai: bwa-align/output
      input_fastq: fastq
      output_sam: output_sam
    out: [output]

