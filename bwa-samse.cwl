#!/usr/bin/env cwl-runner

cwlVersion: v1.0

baseCommand: [bwa, samse]

class: CommandLineTool

requirements:
- $import: bwa-docker.yml
- $import: envvar-global.yml
- class: InlineJavascriptRequirement

inputs:
  fasta:
    type: File
    doc: |
      Input fasta file in .fa or .fasta format with all indexed files like .amb, .ann, .pac, .sa, .bwt
    inputBinding:
      position: 1
    secondaryFiles:
    - ".amb"
    - ".ann"
    - ".pac"
    - ".sa"
    - ".bwt"

  input_sai:
    type: File
    doc: |
      Input .sai file
    inputBinding:
      position: 2

  input_fastq:
    type: File
    doc: |
      Input .fq or .fq.gz file
    inputBinding:
      position: 3

  alignments:
    type: int?
    doc: |
      Maximum number of alignments to output in the XA tag for reads paired properly. If a read has more than INT hits, the XA tag will not be written. 
    inputBinding:
      position: 1
      prefix: "-n"

  read_group:
    type: string?
    doc: |
      Specify the read group in a format like ‘@RG\tID:foo\tSM:bar’.gaps [-1]
    inputBinding:
      position: 1
      prefix: "-r"

  output_sam:
    type: string
    doc: |
      Output filename with .sam
    inputBinding:
      position: 4
      prefix: "-f"

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_sam)

