#!/usr/bin/env cwl-runner

cwlVersion: v1.0

baseCommand: [cut, -f]

class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

inputs:
  file1:
    type: File
    doc: |
      Input file from which 5th and 6th column is taken out
    inputBinding:
      position: 1
      prefix: 5-6

outputs:
  output:
    type: stdout

stdout: $(inputs.file1.basename+".c56")

