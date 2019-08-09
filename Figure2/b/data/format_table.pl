#!/usr/bin/perl -w
#
# Copyright 2016 Boyang JI <boyangji@gmail.com>
#

use strict;
use Data::Dumper;
use Getopt::Long;

use File::Spec::Functions;

my $input_file = $ARGV[0];


# my $species_pairs;
my @head_line;
my $column_info;
my $num_pairs;

open(IN, "<$input_file"), or die "Error in reading $input_file due to $!\n";
while (<IN>) 
{
	if ($.==1) 
	{
		chomp $_;
		@head_line = split/,/, $_;
		$num_pairs = ($#head_line+1)/2;
	}
	else 
	{
		chomp $_;
		my @line = split/,/, $_;
		for (my $i = 1; $i <=$#line+1 ; $i++) 
		{
			push @{$column_info->{$i}}, $line[$i-1];
		}
		
	}
	
}
close IN;

for (my $i = 1; $i <= $num_pairs ; $i++) 
{
	my $s1 = $head_line[$i*2-2];
	my $s2 = $head_line[$i*2-1];
	
	my @info_1 = @{$column_info->{$i*2-1}};
	my @info_2 = @{$column_info->{$i*2}};
	
	print $s1, "\t", $s2, "\t", join("\t", @info_1), "\t", join("\t", @info_2), "\n";
}
