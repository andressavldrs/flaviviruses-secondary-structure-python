#!/usr/bin/perl -w
use strict;

if (@ARGV == 4 ) 
{
	my ($f_gb, $f_output, $min_utr, $op) = @ARGV;
	my $total_length, my $utr5, my $utr3, my $id; 


	my %seq_ids; #hash: id => total_length
	
	open (my $in, '<', $f_gb) #sequence.gb file	
		or die "Can't open input file \"$f_gb\": $!\n"; 
	open (my $out, '>', $f_output)	#id utr total
		or die "Can't open input file \"$f_output\": $!\n";  
	

	while (my $line = <$in>)	
	{
		#LOCUS       FJ654700               10862 bp    RNA     linear   VRL 04-MAR-2009
		if($line =~  m/^LOCUS\s+(\S+)\s+(\S+).*$/)
		{
			$id = $1.".1";
			$total_length = $2;
	
		}
		#     CDS             119..10354
		elsif($line =~  m/^\s+CDS\s+(\w*)..(\w*).*/){
			$utr5 = $1 - 1; #$cds start position - 1
			$utr3 = $total_length - $2; #$total_length - $cds_length

			if(($op == 5) && $utr5 >= $min_utr){
				print $out "$id $utr5 $2\n";
			}
			elsif($utr3 >= $min_utr){
				print $out "$id $utr3 $2\n" ;
			}
		}
	}
	
close($in);
close($out);

}
else 
{
	print "Error: Missing arguments!";
}
