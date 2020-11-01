#!/usr/bin/perl -w
use strict;

if (@ARGV == 3 ) 
{
	my ($f_sequence, $f_ids, $f_output) = @ARGV;
	my $utr_size = 0, my $x = 0, my $y = 0;
	my %sequences; 


	my %seq_ids; #hash: id => total_length
	
	open (my $in, '<', $f_sequence)	or die "Can't open input file \"$f_sequence\": $!\n"; #sequence.fa file
	open (my $id, '<', $f_ids)		or die "Can't open input file \"$f_ids\": $!\n"; #file w ids and cds length 
	open (my $out, '>', $f_output)	or die "Can't open input file \"$f_output\": $!\n";  #sequences w only 3utr region
	

	while (my $line = <$id>)	
	{
#		Atribui os ids ao hash %ids_sequences{$id} = $cds_length	
		
		if($line =~  m/(\S*) (\d*) \d*/) #KT276273 384 10265
		{
			$seq_ids{$1} = $2; #utr size
		}
	}	

	while (my $line = <$in>)	
	{
		if($line =~  m/>(\S*).*/ && $seq_ids{$1}) #>FJ882601 |Homo sapiens|USA|1999 && id exists 
		{

			print $out "$line";
			$x = $seq_ids{$1}%70; #characters to catch
			$y = int($seq_ids{$1}/70); #lines to catch
			#print "lines:$y	characters:$x\n";
	
		}
		elsif($line =~  m/>(\S*).*/ || $x==-1){
			$y = -1;
			$x = -2; 
		}
		elsif($y > 0){
			$y--;
			print $out "$line";
				
		}
		elsif($x>=0 && $y==0){
			$line =~ m/^([A-Z]{$x}).*/;
			$x = -1;
			my $seq = $1;
			print $out "$seq\n\n";
		}

	}

close($in);
close($id);
close($out);

}
else 
{
	print "Error: Missing arguments!";
}
