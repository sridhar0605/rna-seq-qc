#!/usr/bin/bash

## Usage: bash reservoir_downsample_pe.sh 1000 a.fastq.gz b.fastq.gz a.downsampled.fastq.gz b.downsampled.fastq.gz
## Downsampling has NO seed!!!

bindir=$(dirname $0)

DIFF=$(diff <(pigz -dc ${2} | sed -n '1p;1~4p' | sed 's/\t/ /g' | cut -d " " -f1) <(pigz -dc ${3} | sed -n '1p;1~4p' | sed 's/\t/ /g' | cut -d " " -f1))
if [ "$DIFF" != "" ]
then
    echo "Error! FASTQ sequence identifiers do NOT match!"
    exit 1
else
    paste <(zcat ${2} | sed '/^$/d' | sed 's/\t/ /g' | paste -d "\t" - - - - ) <(zcat ${3} | sed '/^$/d' | sed 's/\t/ /g' | paste -d "\t" - - - - ) \
    | $bindir/reservoir ${1} \
    | tee >(cut -f1,2,3,4 | sed 's/\t/\n/g' | gzip > ${4}) >(cut -f5,6,7,8 | sed 's/\t/\n/g' | gzip > ${5}) >/dev/null
fi

### 2nd check
#DIFF=$(diff <(pigz -dc ${4} | sed -n '1p;1~4p' | cut -d " " -f1) <(pigz -dc ${5} | sed -n '1p;1~4p' | cut -d " " -f1))
#if [ "$DIFF" != "" ]
#then
#    echo "Error! FASTQ sequence identifiers do NOT match AFTER DOWNSAMPLING!"
#    exit 1
#fi
