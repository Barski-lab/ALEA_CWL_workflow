#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

doc: |
  samtools-sort.cwl is developed for CWL consortium
    Usage: samtools sort [options...] [in.bam]
    Options:
      -l INT     Set compression level, from 0 (uncompressed) to 9 (best)
      -m INT     Set maximum memory per thread; suffix K/M/G recognized [768M]
      -n         Sort by read name
      -o FILE    Write final output to FILE rather than standard output
      -O FORMAT  Write output as FORMAT ('sam'/'bam'/'cram')   (either -O or
      -T PREFIX  Write temporary files to PREFIX.nnnn.bam       -T is required)
      -@ INT     Set number of sorting and compression threads [1]

    Legacy usage: samtools sort [options...] <in.bam> <out.prefix>
    Options:
      -f         Use <out.prefix> as full final filename rather than prefix
      -o         Write final output to stdout rather than <out.prefix>.bam
      -l,m,n,@   Similar to corresponding options above

requirements:
- $import: envvar-global.yml
- $import: samtools-docker.yml
- class: InlineJavascriptRequirement

inputs:
 compression_level:
  type: int?
  doc: |
    Set compression level, from 0 (uncompressed) to 9 (best)
  inputBinding:
    prefix: "-l"

 memory:
  type: string?
  doc: |
    Set maximum memory per thread; suffix K/M/G recognized [768M]
  inputBinding:
    prefix: "-m"

 sort_by_name:
  type: boolean?
  doc: "Sort by read names (i.e., the QNAME field) rather than by chromosomal coordinates."
  inputBinding:
    prefix: -n

 threads:
  type: int?
  doc: "Set number of sorting and compression threads [1]"
  inputBinding:
    prefix: -@

 output_name:
  type: string
  doc: "Desired output filename."
  inputBinding:
    position: 2

 input:
  type: File
  doc:
    Input bam file.
  inputBinding:
    position: 1

outputs:
 sorted:
  type: File
  outputBinding:
    glob: $(inputs.output_name)

baseCommand: ["samtools", "sort"]

arguments:
  - "-f"
