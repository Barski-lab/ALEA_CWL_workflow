cwlVersion: v1.0
class: Workflow
inputs:
  bam_file1: 
    type: File
    doc: |
      BAM file

  bam_file2: 
    type: File
    doc: |
      BAM file 2

outputs:
  concat_out: 
    type: File
    outputSource: paste/output

    
steps:
  
  cut1:
    run: cut.cwl
    in:
      file1: bam_file1
    out: [output]

  cut2:
    run: cut.cwl
    in:
      file1: bam_file2
    out: [output]

  paste:
    run: paste.cwl
    in:
      file1: cut1/output
      file2: cut1/output
    out: [output]