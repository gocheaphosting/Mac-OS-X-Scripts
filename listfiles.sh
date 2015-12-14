#! /bin/bash

find data/1_Cozumel/ -type f | \
sed 's/^\(.*\/\)/\1 /' |\
sort -nk2 |\
sed 's/^\(.*\([\([iImMgG]\)|\([dD]200\)|\([mMvViI]\)|\([lLeEtT]\)]\).*\)$/\1 \2/' |\
column -t