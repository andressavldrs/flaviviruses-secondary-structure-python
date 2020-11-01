#!/usr/bin/perl -w
use strict;

if (@ARGV == 4 ) 
{
	my ($f_sequence,$f_output, $reg2, $reg3) = @ARGV;
	my $id, my $reg1, my %sequences; #hash: id => sequence
	
	#sequence.fa file
	open (my $in, '<', $f_sequence)	
		or die "Can't open input file \"$f_sequence\": $!\n"; 
		
	#sequences w only 3utr region
	open (my $out1, '>', $f_output."_R1.fa")	
		or die "Can't open input file \"$f_output\": $!\n";  
	#sequences w only 3utr region
	open (my $out2, '>', $f_output."_R2.fa")	
		or die "Can't open input file \"$f_output\": $!\n";  
	#sequences w only 3utr region
	open (my $out3, '>', $f_output."_R3.fa")	
		or die "Can't open input file \"$f_output\": $!\n";  

	
	# popula o hash %sequences com as sequencias e seus respectivos ids
	while (my $line = <$in>)	
	{
	# Atribui os ids ao hash %ids_sequences{$id} = $cds_length	
		
		if($line =~  m/>(\S*)\s.*/)
		{
			#>GQ868618 |Homo sapiens|Cambodia|2003
			$id = $line;
		}else{
			$line =~ s/\s+//g;
			$sequences{$id} .= $line;
		}
	}	

	# printa a sequencias e seus ids no formato fasta
	foreach my $key (keys %sequences){
		if($sequences{$key} =~ m/^(\w*)(\w{$reg2})(\w{$reg3})$/){
				$reg1 = length($1);
				print $out1 "$key$1\n";
				print $out2 "$key$2\n";
				print $out3 "$key$3\n";
		}

	}
#print "$reg1\n";

	
close($in);
close($out1);
close($out2);
close($out3);

}
else 
{
	print "Error: Missing arguments!";
}
