#!/bin/bash

DIR=/data
SEQ=$1 #sequence fasta
XML=$2      # xml with regions data
OUT_ID=$3   #output id
MIN=$4      #min nucleotides value

function utr5 {
    echo "5'UTR"
}

function utr3 {
    # echo $XML $OUT_ID $MIN 
    # parse a XML file and returns a file with ID   UTR LENGTH  CDS POSITION OP
    perl XMLparser.pl $XML $DIR/${OUT_ID}_ids.txt $MIN 3

    # select the 3 most frequents occurrences and returns files with sequences 
    <$DIR/${OUT_ID}_ids.txt  awk '{h[$2]++} END { for(k in h) print k, h[k] }' | sort -k2 -nr | 
    head -n 3 | while read VAR1 VAR2
    do
        echo "3'UTR: ${VAR1}nt -> $VAR2"
        perl select_utr.pl $DIR/${OUT_ID}_ids.txt $VAR1 $DIR/${OUT_ID}_${VAR1}_ids.txt
        perl get_3UTR.pl $SEQ $DIR/${OUT_ID}_${VAR1}_ids.txt $DIR/${OUT_ID}_${VAR1}_3UTR.fa
    done

    echo done
    exit
}



echo "Select genome region"
OPTIONS="5'UTR 3'UTR help exit"
    select opt in $OPTIONS; do 
        if [ "$opt" = "5'UTR" ]; then
            utr5
        elif [ "$opt" = "3'UTR" ]; then
            utr3
        elif [ "$opt" = "help" ]; then
            echo HELP
        elif [ "$opt" = "exit" ]; then
            echo done
            exit
        else
            clear
            echo bad option
        fi
    done