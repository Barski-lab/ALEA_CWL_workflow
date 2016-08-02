#!/usr/bin/env cwl-runner

cwlVersion: v1.0

baseCommand: [bwa, samse]

class: CommandLineTool

requirements:
- $import: bwa-docker.yml
- $import: envvar-global.yml
- class: InlineJavascriptRequirement

inputs:
  fasta:
    type: File
    doc: |
      Input fasta file in .fa or .fasta format with all indexed files like .amb, .ann, .pac, .sa, .bwt
    inputBinding:
      position: 1
    secondaryFiles:
    - ".amb"
    - ".ann"
    - ".pac"
    - ".sa"
    - ".bwt"

  input_sai:
    type: File
    doc: |
      Input .sai file
    inputBinding:
      position: 2

  input_fastq:
    type: File
    doc: |
      Input .fq or .fq.gz file
    inputBinding:
      position: 3

  alignments:
    type: int?
    doc: |
      Maximum number of alignments to output in the XA tag for reads paired properly. If a read has more than INT hits, the XA tag will not be written. 
    inputBinding:
      position: 4
      prefix: "-n"

  read_group:
    type: string?
    doc: |
      Specify the read group in a format like ‘@RG\tID:foo\tSM:bar’.gaps [-1]
    inputBinding:
      position: 5
      prefix: "-r"

  output_sam:
    type: string
    doc: |
      Output filename with .sam
    inputBinding:
      position: 6
      prefix: "-f"

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_sam)

$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/docs/schema_org_rdfa.html

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

