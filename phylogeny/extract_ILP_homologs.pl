#!/usr/bin/perl -w
use strict;

my $pep_file = $ARGV[0];
my $interpro_tsv = $ARGV[1];

my %pep; my $id;
open IN, "< $pep_file" or die "Can't open $pep_file!\n";
while (<IN>)    {
        if (/>(\S+)/)   {
                $id = $1;
        }       else    {
                s/\s//g;
                $pep{$id} .= $_;
        }
}
close (IN);

my %domain; my @id;
open IN, "< $interpro_tsv" or die "Can't open $interpro_tsv!\n";
while (<IN>)    {
        next unless (/\tIPR016179\t/);
        my @hit = split /\t/;
        if ($hit[0] =~ /^(\S+)\-([^\-]+)$/)     {
                @id = ($1, $2);
        }
        if (!defined($domain{$id[0]}->{$id[1]}) || ($domain{$id[0]}->{$id[1]} < $hit[7] - $hit[6] + 1))    {
                $domain{$id[0]}->{$id[1]} = $hit[7] - $hit[6] + 1;
        }
}
close (IN);

foreach my $gene (sort keys %domain)       {
        my %gene;
        my @pep = sort {$gene{$b}<=>$gene{$a}} keys %gene;
        $id = "$gene-$pep[0]";
        print ">$id\n$pep{$id}\n";
}

exit;
