#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement

doc: |
   ALEA - ALIGN READS workflow.
   Step1: bwa-align + bwa-samse (Align) Align the fastq file with strain. fasta files. 
   Step2: Remove the MAPQ and CIGAR columns in the SAM file
   Step3: Create samheader into a SAM FILE
   Step4: Detect the allelic reads and write the output to SAM FILE
   Step5: Convert the output to sorted bam file.

inputs:
  fastq: 
    type: File
    doc: |
      Fastq file.

  genome1_fasta: 
    type: File
    doc: |
      Strain1_Fasta file

  genome2_fasta:
    type: File
    doc: |
      Strain2_Fasta file

  saifile1_prefix:
    type: string
    doc: |
      sai output file from step 1. (fastq prefix + genome1_fasta prefix + '.sai')

  saifile2_prefix:
    type: string
    doc: |
      sai output file from step 1 (fastq prefix + genome2_fasta prefix + '.sai')

  sam_name1:
    type: string
    doc: |
      sai output sam file from step 2. (fastq prefix + genome1_fasta prefix + '.sam')

  sam_name2:
    type: string
    doc: |
      sai output sam file from step 2 (fastq prefix + genome2_fasta prefix + '.sam')

  output_bam1:
    type: string
    doc: |
      sai output bam file (fastq prefix + genome2_fasta prefix + '.bam')
  
  output_bam2: 
    type: string
    doc: |
      sai output bam file (fastq prefix + genome2_fasta prefix + '.bam')

  threads: 
    type: int?
    doc: |
     Threads for bwa-align default is 0

  isheader:
    type: boolean?
    default: true
    doc: |
      Always true

  isbam:
    type: boolean?
    default: true
    doc: |
      Always true

outputs: 
  output1:
    type: File
    outputSource: sam_bam_sort1/bam1

  output2:
    type: File
    outputSource: sam_bam_sort2/bam2

steps:
  bwa_part1:
    run: workflow.cwl
    in:
      fastq: fastq
      genome1_fasta: genome1_fasta
      saifile: saifile1_prefix
      output_sam: sam_name1
      threads: threads
    out: [bwa1_output]

  bwa_part2:
    run: workflow.cwl
    in:
      fastq: fastq
      genome1_fasta: genome2_fasta
      saifile: saifile2_prefix
      output_sam: sam_name2
      threads: threads
    out: [bwa2_output]
  
  awk_paste:
    run: workflow2.cwl
    in:
      bam_file1: bwa_part1/bwa1_output
      bam_file2: bwa_part2/bwa2_output
    out: [awk_paste_output]

  sam_view1:
    run: samtools-view.cwl
    in:
      input: bwa_part1/bwa1_output
      output_name: sam_name1
      isHeader: isheader
    out: [sam_view1_output]

  sam_view2:
    run: samtools-view.cwl
    in:
      input: bwa_part2/bwa2_output
      output_name: sam_name2
      isHeader: isheader
    out: [sam_view2_output]

  awk_component1:
    run: awk_component.cwl
    in: 
      file1: awk_paste/awk_paste_output
      file2: bwa_part1/bwa1_output
    out: [awk_component1_output]

  awk_component2:
    run: awk_component.cwl
    in: 
      file1: awk_paste/awk_paste_output
      file2: bwa_part2/bwa2_output
    out: [awk_component2_output]

  append1:
    run: append.cwl
    in:
      file: sam_view1/sam_view1_output
      file: awk_component1/awk_component1_output
    out: [append1_output]

  append2:
    run: append.cwl
    in: 
      file: sam_view2/sam_view2_output
      file: awk_component2/awk_component2_output
    out: [append2_output]

  sam_bam_sort1:
    run: sam_bam_sorted.cwl
    in:
      sam_file: append1/append1_output
      isbam: isbam
      output_bam: output_bam1
    out: [bam1]

  sam_bam_sort2:
    run: sam_bam_sorted.cwl
    in:
      sam_file: append2/append2_output
      isbam: isbam
      output_bam: output_bam2
    out: [bam2]

