#!/usr/bin/perl -w
use strict;

if (@ARGV == 3) 
{
	my ($f_ids, $utr_size, $f_output) = @ARGV;

	open (my $id, '<', $f_ids)		or die "Can't open input file \"$f_ids\": $!\n"; #file w ids and cds length 
	open (my $out, '>', $f_output)	or die "Can't open input file \"$f_output\": $!\n";  #sequences w only 3utr region
	
	while (my $line = <$id>)	
	{
	# Seleciona apenas os ids com a regiao utr do tamanho indicado
		
		if($line =~  m/(\S*) (\d*) (\d*)/ && ($utr_size == $2)) #KT276273 384 10265
		{
			print $out $line;
		}
	}	

close($id);
close($out);

}
else 
{
	print "Error: Missing arguments!";
}
