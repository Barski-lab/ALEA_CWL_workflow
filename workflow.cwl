cwlVersion: v1.0
class: Workflow
inputs:
  fastq: 
    type: File
    doc: |
      Fastq file

  genome1_fasta: 
    type: File
    doc: |
      Strain1_Fasta file

  saifile:
    type: string
    doc: |
      Sai output prefix with .sai
  
  threads: 
    type: int?
    doc: |
     Threads for bwa-align default is 0
  
  output_sam:
    type: string
    doc: |
      Final sam_file with .sam

outputs:
  output_sam:
    type: File
    outputSource: bwa-samse/samfile

steps:
  bwa-align:
    run: bwa-align.cwl
    in:
      prefix: genome1_fasta
      input: fastq
      output_dir_file: saifile
      threads: threads
    out: [output]

  bwa-samse:
    run: bwa-samse.cwl
    in:
      fasta: genome1_fasta
      input_sai: bwa-align/output
      input_fastq: fastq
      output_sam: output_sam
    out: [samfile]

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

