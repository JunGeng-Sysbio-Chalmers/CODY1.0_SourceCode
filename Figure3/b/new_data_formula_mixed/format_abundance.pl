#!/usr/bin/perl -w
#
# Copyright 2016 Boyang JI <boyangji@gmail.com>
#

use strict;
use Data::Dumper;
use Getopt::Long;

use File::Spec::Functions;

my $anno_file = $ARGV[0];
my $abundance_file = $ARGV[1];

my $out_file_single = $ARGV[2];
my $out_file_all = $ARGV[3];

my $type = $ARGV[4];

my $id;
my $species_id_info;

open(ANNO, "<$anno_file"), or die "Error in reading $anno_file due to $!\n";
while (<ANNO>) 
{
	next if $.==1;
	chomp $_;
	my @info = split/\t/, $_;
	$id->{$info[0]} = $info[6];
	$species_id_info->{$info[6]}->{$info[0]} = 1;
}
close ANNO;

my @samples;
my $abundance;

open(SING, ">$out_file_single"), or die "Error in writing $out_file_single due to $!\n";
print SING "MetaOTU\tSpecies\tType\tSample\tRelativeAbundance\n";

open(AB, "<$abundance_file"), or die "Error in reading $abundance_file due to $!\n";
while (<AB>) 
{
	if ($.==1) 
	{
		chomp $_;
		my @info = split/\t/, $_;
		@samples = map {$_ =~ s/_.+$//; $_} @info;
	}
	else 
	{
		chomp $_;
		my @info = split/\t/, $_;
		my $otu = shift @info;
		if ($id->{$otu}) 
		{
			for (my $i = 0; $i <=$#samples ; $i++) 
			{
				print SING $otu, "\t", $id->{$otu}, "\t", $type, "\t", $samples[$i], "\t", $info[$i], "\n";
				$abundance->{$otu}->{$samples[$i]} = $info[$i];
			}
			
		}
		else 
		{
			next;
		}
		
	}
	
}
close AB;

close SING;

open(ALL, ">$out_file_all"), or die "Error in writing $out_file_all due to $!\n";
print ALL "MetaOTU\tSpecies\tType\tSample\tRelativeAbundance\n";

foreach my $sp (sort keys %$species_id_info) 
{
	my @otus = keys %{$species_id_info->{$sp}};
	
	my $num_otu = $#otus + 1;
	if ($num_otu == 1) 
	{
		my $otu = $otus[0];
		foreach my $s (@samples) 
		{
			print ALL $otu, "\t", $sp, "\t", $type, "\t", $s, "\t", $abundance->{$otu}->{$s}, "\n";
		}
		
	}
	else 
	{
		foreach my $s (@samples) 
		{
			my $abundance_otu;
			foreach my $otu (@otus) 
			{
				$abundance_otu += $abundance->{$otu}->{$s};
			}
			print ALL join(";", @otus), "\t", $sp, "\t", $type, "\t", $s, "\t", $abundance_otu, "\n";
		}
		
	}
	
	
}


close ALL;