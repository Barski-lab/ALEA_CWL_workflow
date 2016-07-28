#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

doc: |
  samtools-view.cwl is developed for CWL consortium
    Usage:   samtools view [options] <in.bam>|<in.sam>|<in.cram> [region ...]

    Options: -b       output BAM
             -C       output CRAM (requires -T)
             -1       use fast BAM compression (implies -b)
             -u       uncompressed BAM output (implies -b)
             -h       include header in SAM output
             -H       print SAM header only (no alignments)
             -c       print only the count of matching records
             -S       If the 
             -o FILE  output file name [stdout]
             -U FILE  output reads not selected by filters to FILE [null]
             -t FILE  FILE listing reference names and lengths (see long help) [null]
             -T FILE  reference sequence FASTA FILE [null]
             -L FILE  only include reads overlapping this BED FILE [null]
             -r STR   only include reads in read group STR [null]
             -R FILE  only include reads with read group listed in FILE [null]
             -q INT   only include reads with mapping quality >= INT [0]
             -l STR   only include reads in library STR [null]
             -m INT   only include reads with number of CIGAR operations
                      consuming query sequence >= INT [0]
             -f INT   only include reads with all bits set in INT set in FLAG [0]
             -F INT   only include reads with none of the bits set in INT
                      set in FLAG [0]
             -x STR   read tag to strip (repeatable) [null]
             -B       collapse the backward CIGAR operation
             -s FLOAT integer part sets seed of random number generator [0];
                      rest sets fraction of templates to subsample [no subsampling]
             -@ INT   number of BAM compression threads [0]

requirements:
- $import: envvar-global.yml
- $import: samtools-docker.yml
- class: InlineJavascriptRequirement

inputs:
 input:
  type: File
  doc: |
    Input bam file.
  inputBinding:
    position: 4

 region:
  type: string?
  doc: |
    [region ...]
  inputBinding:
    position: 5

 output_name:
  type: string
  inputBinding:
    position: 2
    prefix: "-o"

 isbam:
  type: boolean
  default: false
  doc: |
    output in BAM format
  inputBinding:
    position: 2
    prefix: "-b"

 iscram:
  type: boolean
  default: false
  doc: |
    output in CRAM format
  inputBinding:
    position: 2
    prefix: "-C"
 
 isHeader:
  type: boolean
  default: false
  doc: |
    Output only headers
  inputBinding:
    position: 2
    prefix: "-H"

 fastcompression:
  type: boolean
  default: false
  doc: |
    use fast BAM compression (implies -b)
  inputBinding:
    position: 1
    prefix: "-1"

 uncompressed:
  type: boolean
  default: false
  doc: |
    uncompressed BAM output (implies -b)
  inputBinding:
    position: 1
    prefix: "-u"

 samheader:
  type: boolean
  default: false
  doc: |
    include header in SAM output
  inputBinding:
    position: 1
    prefix: "-h"

 count:
  type: boolean
  default: false
  doc: |
    print only the count of matching records
  inputBinding:
    position: 1
    prefix: "-c"

 referencefasta:
  type: File?
  doc: |
    reference sequence FASTA FILE [null]
  inputBinding:
    position: 1
    prefix: "-T"

 bedoverlap:
  type: File?
  doc: |
    only include reads overlapping this BED FILE [null]
  inputBinding:
    position: 1
    prefix: "-L"

 readsingroup:
  type: string?
  doc: |
    only include reads in read group STR [null]
  inputBinding:
    position: 1
    prefix: "-r"

 readsingroupfile:
  type: File?
  doc: |
    only include reads with read group listed in FILE [null]
  inputBinding:
    position: 1
    prefix: "-R"

 readsquality:
  type: int?
  doc: |
    only include reads with mapping quality >= INT [0]
  inputBinding:
    position: 1
    prefix: "-q"

 readsinlibrary:
  type: string?
  doc: |
    only include reads in library STR [null]
  inputBinding:
    position: 1
    prefix: "-l"

 cigar:
  type: int?
  doc: |
    only include reads with number of CIGAR operations
    consuming query sequence >= INT [0]
  inputBinding:
    position: 1
    prefix: "-m"

 readswithbits:
  type: int?
  doc: |
    only include reads with all bits set in INT set in FLAG [0]
  inputBinding:
    position: 1
    prefix: "-f"

 readswithoutbits:
  type: int?
  doc: |
    only include reads with none of the bits set in INT set in FLAG [0]
  inputBinding:
    position: 1
    prefix: "-F"

 readtagtostrip:
  type: string[]?
  inputBinding:
      prefix: "-x"
      position: 1
  doc: |
    read tag to strip (repeatable) [null]
    
 collapsecigar:
  type: boolean
  default: false
  doc: |
    collapse the backward CIGAR operation
  inputBinding:
    position: 1
    prefix: "-B"

 randomseed:
  type: float?
  doc: |
    integer part sets seed of random number generator [0];
    rest sets fraction of templates to subsample [no subsampling]
  inputBinding:
    position: 1
    prefix: "-s"

 threads:
  type: int?
  doc: |
    number of BAM compression threads [0]
  inputBinding:
    position: 1
    prefix: "-@"

outputs:
 output:
  type: File
  outputBinding:
    glob: $(inputs.output_name)

baseCommand: ["samtools", "view"]

$namespaces:
  s: http://schema.org/

$schemas:
- https://sparql-test.commonwl.org/schema.rdf

s:mainEntity:
  $import: samtools-metadata.yaml

s:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/samtools-view.cwl
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