#!/usr/bin/env cwl-runner

cwlVersion: v1.0

baseCommand: [paste]

class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

inputs:
  file1:
    type: File
    doc: |
      Input file 1
    inputBinding:
      position: 1

  file2:
    type: File
    doc: |
      Input file 2 
    inputBinding:
      position: 2

outputs:
  output:
    type: stdout

stdout: $(inputs.file1.basename.split("/").slice(0,2- 1).join("/")+("/")+inputs.file1.nameroot+"_"+inputs.file2.nameroot+inputs.file1.nameext+inputs.file2.nameext.split('.')[1])
