#!/bin/bash

SEQ=$1 #sequence fasta
FILE=$2      # xml with regions data
OUT_ID=$3   #output id
MIN=$4      #min nucleotides value

REG2=152 # Size of 3'UTR region 2
REG3=126 # Size of 3'UTR region 3

function utr5 {
    if [[ $FILE = *.gb ]]; then
    # parse a Genbank file and returns a file with ID   UTR LENGTH  CDS POSITION     
        perl GBparser.pl $FILE ${OUT_ID}_ids.txt $MIN 5
    # parse a XML file and returns a file with ID   UTR LENGTH  CDS POSITION
    else 
        perl XMLparser.pl $FILE ${OUT_ID}_ids.txt $MIN 5
    fi
        
    <${OUT_ID}_ids.txt  awk '{h[$2]++} END { for(k in h) print k, h[k] }' | sort -k2 -nr | 
    head -n 1 | while read VAR1 VAR2
    do
        echo "5'UTR: ${VAR1}nt -> $VAR2"
        perl select_utr.pl ${OUT_ID}_ids.txt $VAR1 ${OUT_ID}_${VAR1}_ids.txt
        perl get_5UTR.pl $SEQ ${OUT_ID}_${VAR1}_ids.txt ${OUT_ID}_${VAR1}_5UTR.fa
    done

}

function utr3 {
        if [[ $FILE = *.gb ]]; then
    # parse a Genbank file and returns a file with ID   UTR LENGTH  CDS POSITION    
        perl GBparser.pl $FILE ${OUT_ID}_ids.txt $MIN 3
    # parse a XML file and returns a file with ID   UTR LENGTH  CDS POSITION
    else  
        perl XMLparser.pl $FILE ${OUT_ID}_ids.txt $MIN 3
    fi
    # select the most frequent occurrence and returns files with sequences 
    <${OUT_ID}_ids.txt  awk '{h[$2]++} END { for(k in h) print k, h[k] }' | sort -k2 -nr | 
    head -n 1 | while read VAR1 VAR2
    do
        echo "3'UTR: ${VAR1}nt -> $VAR2"
        perl select_utr.pl ${OUT_ID}_ids.txt $VAR1 ${OUT_ID}_${VAR1}_ids.txt
        perl get_3UTR.pl $SEQ ${OUT_ID}_${VAR1}_ids.txt ${OUT_ID}_${VAR1}_3UTR.fa
        perl select_regions.pl ${OUT_ID}_${VAR1}_3UTR.fa ${OUT_ID} $REG2 $REG3
    done
}



echo "Select genome region"
OPTIONS="5'UTR 3'UTR help exit"
    select opt in $OPTIONS; do 
        if [ "$opt" = "5'UTR" ]; then
            utr5
        elif [ "$opt" = "3'UTR" ]; then
            utr3
        elif [ "$opt" = "help" ]; then
            echo " To execute the script: ./autorun.sh sequence.fa data.xml output_id nucleotides_minimum" 
            echo " Option 5'UTR gets the genome region 5'UTR"
            echo " Option 3'UTR gets the genome region 3'UTR"
            exit
        elif [ "$opt" = "exit" ]; then
            echo done
            exit
        else
            clear
            echo bad option
        fi
    done