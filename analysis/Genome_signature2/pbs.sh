#!/bin/sh
#PBS -q small
#PBS -l ncpus=1
#PBS -V
cd ${PBS_O_WORKDIR}

mkdir -p logs
(time perl -I/home/haruo/g-language-1.9.1/lib /home/haruo/scripts/run_g_gbk_multiple2single.pl "${gbk}") >& logs/log.g_gbk_multiple2single.$(basename "${gbk}").$(date +%F).txt

