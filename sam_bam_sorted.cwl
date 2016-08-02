cwlVersion: v1.0
class: Workflow
inputs:
  sam_file:
    type: File
    doc: |
      Input Sam file

  isbam:
    type: boolean?
    default: true

  output_bam:
    type: string
    doc: |
      Output Name

outputs:
  output:
    type: File
    outputSource: sam_sort/output

steps:
  sam_view:
    run: samtools-view.cwl
    in:
      input: sam_file
      output_name: output_bam
      isbam: isbam
    out: [output]

  sam_sort:
    run: samtools-sort.cwl
    in:
      input: sam_view/output
      output_name: output_bam
    out: [output]

