#!/usr/bin/env cwl-runner

cwlVersion: v1.0

baseCommand: [bwa, aln]

class: CommandLineTool

requirements:
- $import: bwa-docker.yml
- $import: envvar-global.yml
- class: InlineJavascriptRequirement

inputs:
  prefix:
    type: File
    inputBinding:
      position: 4
    secondaryFiles:
    - ".amb"
    - ".ann"
    - ".pac"
    - ".sa"
    - ".bwt"

  input:
    type: File
    inputBinding:
      position: 5

  output_dir_file:
    type: string
    inputBinding:
      position: 1
      prefix: "-f"

  threads:
    type: int?
    inputBinding:
      position: 1
      prefix: "-t"

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
      glob: $(inputs.output_filename)

$namespaces:
  s: http://schema.org/

$schemas:
- https://sparql-test.commonwl.org/schema.rdf

s:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/alea-createGenome.cwl
s:codeRepository: https://github.com/common-workflow-language/workflows
s:license: http://www.apache.org/licenses/LICENSE-2.0
s:isPartOf:
  class: s:CreativeWork
  s:name: "Common Workflow Language"
  s:url: http://commonwl.org/

s:author:
  class: s:Person
  s:name: "Andrey Kartashov"
  s:email: mailto:Andrey.Kartashov@cchmc.org
  s:sameAs:
  - id: http://orcid.org/0000-0001-9102-5681
  s:worksFor:
  - class: s:Organization
    s:name: "Cincinnati Children's Hospital Medical Center"
    s:location: "3333 Burnet Ave, Cincinnati, OH 45229-3026"
    s:department:
    - class: s:Organization
      s:name: "Barski Lab"

