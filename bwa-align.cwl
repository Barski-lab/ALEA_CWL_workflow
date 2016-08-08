#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [bwa, aln]

requirements:
- $import: bwa-docker.yml
- $import: envvar-global.yml
- class: InlineJavascriptRequirement

inputs:
  prefix:
    type: File
    inputBinding:
      position: 2
    doc: |
       Input fasta file with all indexed files.
    secondaryFiles:
    - ".ann"
    - ".sa"
    - ".pac"
    - ".amb"
    - ".bwt"

  input:
    type: File
    doc: |
       Input fastq file
    inputBinding:
      position: 3

  output_file_name:
    type: string
    doc: |
       Output file name
    inputBinding:
      position: 4
      prefix: "-f"

  threads:
    type: int?
    inputBinding:
      position: 1
      prefix: "-t"

  n:
    type: int?
    doc: |
        Maximum edit distance if the value is INT, or the fraction of missing alignments given 2% uniform base error rate if FLOAT. In the latter case, the maximum edit distance is automatically chosen for different read lengths. [0.04]
    inputBinding: 
      position: 1
      prefix: "-n"
  o:
    type: int?
    doc: |
      maximum number or fraction of gap opens [1]
    inputBinding:
      position: 1
      prefix: "-o"

  e:
    type: int?
    doc: |
      maximum number of gap extensions, -1 for disabling long gaps [-1]
    inputBinding:
      position: 1
      prefix: "-e"

  i:
    type: int?
    doc: |
      do not put an indel within INT bp towards the ends [5]
    inputBinding:
      position: 1
      prefix: "-i"

  d:
    type: int?
    doc: |
      maximum occurrences for extending a long deletion [10]
    inputBinding:
      position: 1
      prefix: "-d"

  l:
    type: int?
    doc: |
      seed length [32]
    inputBinding:
      position: 1
      prefix: "-l"

  k:
    type: int?
    doc: |
      maximum differences in the seed [2]
    inputBinding:
      position: 1
      prefix: "-k"

  m:
    type: int?
    doc: |
      maximum entries in the queue [2000000]
    inputBinding:
      position: 1
      prefix: "-m"

  I:
    type: boolean?
    doc: |
      the input is in the Illumina 1.3+ FASTQ-like format
    inputBinding:
      position: 1
      prefix: "-I"

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)


