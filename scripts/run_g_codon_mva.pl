# (time perl -I/home/haruo/g-language-1.9.1/lib run_g_codon_mva.pl "NC_002483" &) >& log.$(date +%F).txt

use strict;
use G;

#my $file = "ecoli.gbk"; # NC_000913
#my $file = "plasmidf.gbk"; # NC_002483
my $file = $ARGV[0];
my $gb = load($file); #, "no msg"); # "no cache"
#$gb->output($file.".gbk");

my $del_key = '[^ACDEFGHIKLMNPQRSTVWYacgtU]'; # U Sec Selenocysteine
&codon_mva($gb, -output=>'n', -del_key=>$del_key);

__END__

http://www.g-language.org/wiki/restgenomeanalysisenglish
http://www.g-language.org/wiki/restgenomeanalysisjapanese
