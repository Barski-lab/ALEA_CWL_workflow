cwlVersion: v1.0

class: CommandLineTool

baseCommand: ["alea", "createTracks"]

requirements:
- $import: alea-docker.yml
- $import: envvar-global.yml
- class: InlineJavascriptRequirement
- class: EnvVarRequirement
  envDef:
  - envName: "AL_USE_CONCATENATED_GENOME"
    envValue: $(inputs.CONCATENATED_GENOME?"1":"0")
  - envName: "AL_BWA_ALN_PARAMS"
    envValue: "-k 0 -n 0 -t 4"
  - envName: "AL_DIR_TOOLS"
    envValue: "/usr/local/bin/"

inputs:
 bamfiles:
   type: File[]
   doc: |
      prefix used for the output of alignReads command

 bamprefix:
   type: string?
   doc: |
     Prefix string
   inputBinding:
     position: 2
     valueFrom: |
        ${return inputs.bamfile.dirname+"/"+inputs.bamprefix}
     prefix: "-s"
 
 strain1:
   type: string
   doc: |
      name of strain1 (e.g. hap1)
   inputBinding:
      position: 3
 
 strain2:
   type: string
   doc: |
      name of strain2 (e.g. hap2)
   inputBinding:
      position: 4

 genome1_refmap:
   type: File
   doc: |
      path to the refmap file1 created for createGenome workflow
   inputBinding:
      position: 5

 genome2_refmap:
   type: File
   doc: |
      path to the refmap file2 created for createGenome workflow
   inputBinding:
      position: 6

 chrom_size:
   type: File
   doc: |
      path to the chromosome size file (required for creating .bw)
   inputBinding:
      position: 7
 
 output_dir:
   type: string
   doc: |
     Directory to place the files
   inputBinding:
     position: 8

outputs:
 bedgraph1:
   type: File
   outputBinding:
     glob: $(inputs.output_dir+"/"+inputs.bamprefix+"_"+inputs.strain1+".bedGraph")

 bedgraph2:
   type: File
   outputBinding:
     glob: $(inputs.output_dir+"/"+inputs.bamprefix+"_"+inputs.strain2+".bedGraph")

 wig1:
   type: File
   outputBinding:
     glob: $(inputs.output_dir+"/"+inputs.bamprefix+"_"+inputs.strain1+".wig.gz")

 wig2:
   type: File
   outputBinding:
     glob: $(inputs.output_dir+"/"+inputs.bamprefix+"_"+inputs.strain2+".wig.gz")

 bw1:
   type: File
   outputBinding:
     glob: $(inputs.output_dir+"/"+inputs.bamprefix+"_"+inputs.strain1+".bw")
 
 bw2:
   type: File
   outputBinding:
     glob: $(inputs.output_dir+"/"+inputs.bamprefix+"_"+inputs.strain2+".bw")

$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/docs/schema_org_rdfa.html
