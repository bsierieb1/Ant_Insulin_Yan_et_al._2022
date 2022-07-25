#!/usr/bin/perl -w
use strict;

my $cds_file = $ARGV[0];
my $asm_id = $ARGV[1];

open IN, "< $cds_file" or die "Can't open $cds_file!\n";
while (<IN>)	{
	if (/>lcl\|(\S+).*\[gene\=(\S+)\]/)	{
		print ">$asm_id-$2-$1\n";
	}	else	{
		print $_;
	}
}
close (IN);

exit;