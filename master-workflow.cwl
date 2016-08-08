#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
- class: MultipleInputFeatureRequirement
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement

doc: |
   ALEA - ALIGN READS workflow.
   Step0: Create Genome. Create seperate fasta files for two strains. Creates refmap files + fasta files
   Step1: bwa-align + bwa-samse (Align) Align the fastq file with strain. fasta files. 
   Step2: Remove the MAPQ and CIGAR columns in the SAM file
   Step3: Create samheader into a SAM FILE
   Step4: Detect the allelic reads and write the output to SAM FILE
   Step5: Convert the outputs to sorted bam files.
   Step6: Using the sorted bam files from step5, refmap files from step0 creates .bedgraph, .bw, .wig files

inputs:
  reference:
    type: File
    doc: |
      the reference genome fasta file
    secondaryFiles:
    - '.fai'

  phased:
    type: File
    doc: |
      the phased variants vcf file (including SNPs and Indels)
      or the phased SNPs (should be specified first)
    secondaryFiles:
    - '.tbi'

  phasedindels:
    type: File?
    doc: |
      the phased Indels (should be specified second)
    secondaryFiles:
    - '.tbi'
  
  strain1:
    type: string

  strain2:
    type: string

  fastq: 
    type: File
    doc: |
      Fastq file.

  outputDir:
    type: string
    doc: |
      location of the output directory
  
  CONCATENATED_GENOME:
    type: boolean
    default: false

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

  issam:
    type: boolean?
    default: true
    doc: |
      Always 

  chrom_size:
    type: File
    doc: |
      File of the reference chromosome size in .size format

  bamprefix:
    type: string
    doc: |
      Name of the fastq file without extension.

outputs: 
  output1:
    type: File
    outputSource: sam_bam_sort1/output

  output2:
    type: File
    outputSource: sam_bam_sort2/output

  output3:
    type: File[]
    outputSource: [createtrack/bedgraph1, createtrack/bedgraph2, createtrack/wig1, createtrack/wig2, createtrack/bw1, createtrack/bw2]

steps:
  createGenome:
    run: alea-createGenome.cwl
    in:
      reference: reference
      phased: phased
      phasedindels: phasedindels
      strain1: strain1
      strain2: strain2
      outputDir: outputDir
    out: [strain1_indices, strain2_indices]
  
  bwa_part1:
    run: workflow.cwl
    in:
      fastq: fastq
      genome1_fasta: createGenome/strain1_indices
      saifile: saifile1_prefix
      output_sam: sam_name1
      threads: threads
    out: [output]

  bwa_part2:
    run: workflow.cwl
    in:
      fastq: fastq
      genome1_fasta: createGenome/strain2_indices
      saifile: saifile2_prefix
      output_sam: sam_name2
      threads: threads
    out: [output]
  
  awk_paste:
    run: workflow2.cwl
    in:
      sam_file1: bwa_part1/output
      sam_file2: bwa_part2/output
    out: [concat_out]

  sam_view1:
    run: samtools-view.cwl
    in:
      input: bwa_part1/output
      output_name: sam_name1
      isHeader: isheader
      issam: issam
    out: [output]

  sam_view2:
    run: samtools-view.cwl
    in:
      input: bwa_part2/output
      output_name: sam_name2
      isHeader: isheader
      issam: issam
    out: [output]

  awk_component1:
    run: awk_component.cwl
    in: 
      file1: awk_paste/concat_out
      file2: bwa_part1/output
    out: [output]

  awk_component2:
    run: awk_component2.cwl
    in: 
      file1: awk_paste/concat_out
      file2: bwa_part2/output
    out: [output]

  append1:
    run: append.cwl
    in:
      file: [sam_view1/output, awk_component1/output]
    out: [output]

  append2:
    run: append.cwl
    in: 
      file: [sam_view2/output, awk_component2/output]
    out: [output]

  sam_bam_sort1:
    run: sam_bam_sorted.cwl
    in:
      sam_file: append1/output
      issam: issam
      output_bam: output_bam1
    out: [output]

  sam_bam_sort2:
    run: sam_bam_sorted.cwl
    in:
      sam_file: append2/output
      isbam: isbam
      output_bam: output_bam2
    out: [output]

  createtrack:
    run: alea-createTracks.cwl
    in:
      bamfiles: [sam_bam_sort1/output, sam_bam_sort2/output]
      strain1: strain1
      strain2: strain2
      bamprefix: bamprefix
      genome1_refmap: createGenome/strain1_indices 
      genome2_refmap: createGenome/strain2_indices 
      chrom_size: chrom_size
      output_dir: outputDir

    out: [bedgraph1, bedgraph2, wig1, wig2, bw1, bw2]
