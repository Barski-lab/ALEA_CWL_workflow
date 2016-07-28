#!/usr/bin/env cwl-runner

cwlVersion: v1.0

baseCommand: [awk]

class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

inputs:
  file1:
    type: File
    doc: |
      Input BAM file 1
    inputBinding:
      position: 2

  file2:
    type: File
    doc: |
      Input BAM file 2
    inputBinding: 
      position: 3

outputs:
  output:
    type: stdout

arguments:
   - valueFrom: |
      ${
        var r = '{if (NR==FNR) {if ($1 > $3 && $4 == "*") a[NR]=1;} else {if (FNR in a) print $0;}}';
        return r;
      }
     position: 1

stdout: $(inputs.file1.basename+'_unsorted.bam')
