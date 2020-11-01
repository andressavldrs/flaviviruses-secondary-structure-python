#!/bin/perl -w

#########################################################################
#                                                                       #
#  This program parse a XML file, extracting the ID, total length,      #
#  3`UTR length or 5'UTR length and cds position.                                       #
#  INPUT: XMLparser.pl file.xml output.txt 100                          #
#  OUTPUT: output.txt (ID utr-length cds-position)                      #
#                                                                       #
#########################################################################

use strict;
use XML::Twig;

my ($xmlfile, $output, $min_utr, $op) = @ARGV;
my $entries = 0;
  open(my $fh, ">", $output)
or die "Can't open > $output: $!";

my $t = XML::Twig->new( 
       # the twig will include just the root and selected titles 
           twig_roots   => { 'Item' => \&get_data}
                      );
$t->parsefile( $xmlfile);
print "Number of sequences: $entries\n";
  sub get_data { 
      my( $t, $elt)= @_;
      if(($elt->first_child('old_cds_location')) && ($elt->first_child('length'))){
        my $old_cds_location = $elt->first_child('old_cds_location')->text;    # print the text (including sub-element texts
        my $length =  $elt->first_child('length')->text;

        $old_cds_location =~ m/gb.(\w*):(\d*)-(\S*)/; #gb|LC069810:88-10251

        my $utr3 = $length - $3; #$total_length - $cds_length
        my $utr5 = $2 - 1; #$cds start position - 1
        $entries++;

        if($op == 5 && $utr5 >= $min_utr){
          print $fh "$1 $utr5 $3\n"; 
        }
        elsif($op == 3 && $utr3  >= $min_utr){
          print $fh "$1 $utr3 $3\n";
        }
        elsif($op != 3 && $op != 5){
          print "Wrong opcode! Opcode should be 5 to 5'UTR or 3 to 3'UTR";
        }

      }
      
      $t->purge;           # frees the memory
    }