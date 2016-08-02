#!/usr/bin/env cwl-runner

cwlVersion: v1.0

baseCommand: [cat]

class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

inputs:
  file:
    type: File[]
    doc: |
      Filenames
    inputBinding:
      position: 1

outputs: 
  output: 
    type: stdout

stdout: ${ var r=[];
           r[0]=inputs.file[0].basename;
         for (var i =0; i< inputs.file.length; i++){
         if (inputs.file.length>0){
           r[i]=inputs.file[i].nameroot;
             }
         }
         return r.join('_');
         }