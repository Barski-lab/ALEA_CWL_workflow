cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement

inputs:
  fastq: 
    type: File
    doc: |
      Fastq file

  genome1_fasta: 
    type: File
    doc: |
      Strain1_Fasta file

  genome2_fasta:
    type: File
    doc: |
      Strain2_Fasta file

  saifile1_prefix:
    type: string
    doc: |
      sai output file from step 1

  saifile2_prefix:
    type: string
    doc: |
      sai output file from step 1
  
  threads: 
    type: int?
    doc: |
     Threads for bwa-align default is 0
  
  output_sam:
    type: string
    doc: |
      Final sam_file name without extension

outputs: []
#  output:
#    type: File
#    outputSource: awk_component2/awk_component2_output

steps:
  bwa_part1:
    run: workflow.cwl
    in:
      fastq: fastq
      genome1_fasta: genome1_fasta
      saifile: saifile1_prefix
      threads: threads
    out: [bwa1_output]

  bwa_part2:
    run: workflow.cwl
    in:
      fastq: fastq
      genome2_fasta: genome2_fasta
      saifile: saifile2_prefix
      threads: threads
    out: [bwa2_output]

  awk_paste:
    run: workflow2.cwl
    in:
      bam_file1: bwa_part1/bwa1_output
      bam_file2: bwa_part2/bwa2_output
    out: [awk_paste_output]
  
  sam_view1:
     run: samtool-view.cwl
     in:
       input: bwa_part1/bwa1_output
       output_name: $(bwa_part1/bwa_output1.basename+'unsorted.sam')
       isheader: true
     out: [sam_view1_output]

  sam_view2:
     run: samtool-view.cwl
     in:
       input: bwa_part2/bwa2_output
       output_name: $(bwa_part2/bwa_output2.basename+'unsorted.sam')
     out: [sam_view2_output]

  awk_component1:
     run: awk_component.cwl
     in: 
       file1: awk_paste/awk_paste_output
       file2: bwa_part1/bwa1_output
     out: [awk_component1_output]

  awk_component2:
     run: awk_component.cwl
     in: 
       file1: awk_paste/awk_paste_output
       file2: bwa_part2/bwa2_output
     out: [awk_component2_output]



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

