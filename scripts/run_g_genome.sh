# run_g_gbk_multiple2single.pl
cd ${PBS_O_WORKDIR}

mkdir -p logs
(time perl -I/home/haruo/g-language-1.9.1/lib /home/haruo/scripts/run_g_genome.pl "${gbk}") >& logs/log.g_genome.$(basename "${gbk}").$(date +%F).txt
