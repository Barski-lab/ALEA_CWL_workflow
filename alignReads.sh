
# Adaptation from 
#------------------------------------------------------------------------------------
# Check file exists
#------------------------------------------------------------------------------------
function aleaCheckFileExists {
    if [ ! -f "$1" ]; then
        echo "Error: File $1 does not exist"
        exit 1
    fi
}
function printProgress {
    echo $1 at [`date`]
}
#------------------------------------------------------------------------------------
# detect the allelic reads from the reads aligned to concatenated genome
#------------------------------------------------------------------------------------
function detectAllelicConcatenated {
    
    printProgress "[detectAllelicConcatenated] Started"

     local PARAM_INPUT_SAM=$1
     local PARAM_STRAIN=$2
     local PARAM_REFFASTA=$3   
     local PARAM_QUALITY=$4
     local PARAM_OUT_PREFIX=$5
    
    # output header first
    $AL_BIN_SAMTOOLS view -SH "$PARAM_INPUT_SAM" \
        | awk -v ref="$PARAM_STRAIN" '($0 ~ ref) {print $0}' \
        | sed 's/'"$PARAM_STRAIN"'_chr//g' \
        > "$PARAM_OUT_PREFIX".sam
    
    # append reads
    $AL_BIN_SAMTOOLS view -S $PARAM_INPUT_SAM \
        | awk -v ref="$PARAM_STRAIN" '(($3 ~ ref)&&($5'"$PARAM_QUALITY"')) {print $0}' \
        | sed 's/'"$PARAM_STRAIN"'_chr//g' \
        >> "$PARAM_OUT_PREFIX".sam

    # convert to bam
    $AL_BIN_SAMTOOLS view -bt $PARAM_REFFASTA "$PARAM_OUT_PREFIX".sam > "$PARAM_OUT_PREFIX".unsorted.bam
    
    # sort by coordinates
    $AL_BIN_SAMTOOLS sort "$PARAM_OUT_PREFIX".unsorted.bam "$PARAM_OUT_PREFIX" 
    
    if [ -f "$PARAM_OUT_PREFIX".bam ]
    then
        printProgress "[detectAllelicConcatenated] Filtered BAM file created."
        # remove temp files
        # if [ $AL_DEBUG = 0 ]; then
        #     printProgress "[detectAllelicConcatenated] Removing temporary SAM files."
        #     rm -f "$PARAM_OUT_PREFIX".sam
        #     rm -f "$PARAM_OUT_PREFIX".unsorted.bam
        # fi
    # else
    #     printProgress "[detectAllelicConcatenated] ERROR: Filtered BAM file was not created."
    fi
    printProgress "[detectAllelicConcatenated] Done"
}

#------------------------------------------------------------------------------------
# detect the allelic reads from the reads aligned to separate insilico genomes
#------------------------------------------------------------------------------------
function detectAllelicSeparate {
    printProgress "Detecting Seperate Alleles Started"
    local PARAM_INPUT_SAM1=$1
    local PARAM_INPUT_SAM2=$2
    local PARAM_OUT_PREFIX1=$3
    local PARAM_OUT_PREFIX2=$4

    printProgress "Extracting MAPQ and CIGAR columns to one file"
    # extract MAPQ and CIGAR columns to one file
    awk '{print $5"\t"$6}' "$PARAM_INPUT_SAM1" > "$PARAM_INPUT_SAM1".c56
    awk '{print $5"\t"$6}' "$PARAM_INPUT_SAM2" > "$PARAM_INPUT_SAM2".c56
    paste "$PARAM_INPUT_SAM1".c56 "$PARAM_INPUT_SAM2".c56 > "$PARAM_INPUT_SAM1".c56c56
    
    # create output sam headers
    samtools view -SH "$PARAM_INPUT_SAM1" > "$PARAM_OUT_PREFIX1".unsorted.sam
    samtools view -SH "$PARAM_INPUT_SAM2" > "$PARAM_OUT_PREFIX2".unsorted.sam
    
    # detect allelic reads
    awk '{if (NR==FNR) {if ($1 > $3 && $4 == "*") a[NR]=1;} else {if (FNR in a) print $0;}}' "$PARAM_INPUT_SAM1".c56c56 "$PARAM_INPUT_SAM1" >> "$PARAM_OUT_PREFIX1".unsorted.sam
    awk '{if (NR==FNR) {if ($3 > $1 && $2 == "*") a[NR]=1;} else {if (FNR in a) print $0;}}' "$PARAM_INPUT_SAM1".c56c56 "$PARAM_INPUT_SAM2" >> "$PARAM_OUT_PREFIX2".unsorted.sam
    
    # create .bam
    printProgress "SAM to BAM conversion"
    samtools view -bS "$PARAM_OUT_PREFIX1".unsorted.sam > "$PARAM_OUT_PREFIX1".unsorted.bam
    samtools view -bS "$PARAM_OUT_PREFIX2".unsorted.sam > "$PARAM_OUT_PREFIX2".unsorted.bam
    

    # sort .bam
    printProgress "sorting bam file"
    samtools sort "$PARAM_OUT_PREFIX1".unsorted.bam -o "$PARAM_OUT_PREFIX1"
    samtools sort "$PARAM_OUT_PREFIX2".unsorted.bam -o "$PARAM_OUT_PREFIX2"
    
    # remove temp files
    # if [ $AL_DEBUG = 0 ]; then
    #     rm -f "$PARAM_INPUT_SAM1".c56
    #     rm -f "$PARAM_INPUT_SAM2".c56
    #     rm -f "$PARAM_INPUT_SAM1".c56c56
    #     rm -f "$PARAM_OUT_PREFIX1".unsorted.*
    #     rm -f "$PARAM_OUT_PREFIX2".unsorted.*
    # fi
}

PARAM_VALID=1
if [ $# -eq 6 ]; then
    $samfile=$1
    PARAM_STRAIN1=$2
    PARAM_STRAIN2=$3 
    PARAM_GENOME=$4
    BAM_PREFIX_STRAIN1=$5
    BAM_PREFIX_STRAIN2=$6

    aleaCheckFileExists "$samfile"
    aleaCheckFileExists "$PARAM_GENOME"
    
    detectAllelicConcatenated "$samfile" "$PARAM_STRAIN1" "$PARAM_GENOME" "> 1" "$BAM_PREFIX_STRAIN1"
    detectAllelicConcatenated "$samfile" "$PARAM_STRAIN2" "$PARAM_GENOME" "> 1" "$BAM_PREFIX_STRAIN2"

elif [ $# -eq 4 ]; then
    strain1_all_sam=$1
    strain2_all_sam=$2
    BAM_PREFIX_STRAIN1=$3
    BAM_PREFIX_STRAIN2=$4
    aleaCheckFileExists "$strain1_all_sam"
    aleaCheckFileExists "$strain2_all_sam"

    detectAllelicSeparate "$strain1_all_sam" "$strain2_all_sam" "$BAM_PREFIX_STRAIN1" "$BAM_PREFIX_STRAIN2"
else
    PARAM_VALID=0
fi

if [ $PARAM_VALID = 0 ]; then
    echo "
        Usage: alignReads samfile strain1 ref_genome bam_prefix_strain1 (for concatenated)
               alignReads strain1_sam strain2_sam bam_prefix_strain1 bam_prefix_strain2 (for non-concatenated)

    "
fi
