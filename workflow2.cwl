cwlVersion: v1.0
class: Workflow
inputs:
  sam_file1: 
    type: File
    doc: |
      SAM file 1 (fastq_strain1.sam format)

  sam_file2: 
    type: File
    doc: |
      SAM file 2 (fastq_strain2.sam format)

outputs:
  concat_out: 
    type: File
    outputSource: paste/output

steps:
  cut1:
    run: cut.cwl
    in:
      file: sam_file1
    out: [output]

  cut2:
    run: cut.cwl
    in:
      file: sam_file2
    out: [output]

  paste:
    run: paste.cwl
    in:
      file1: cut1/output
      file2: cut1/output
    out: [output]