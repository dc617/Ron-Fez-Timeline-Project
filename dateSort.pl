#!/usr/bin/perl

use Data::Dumper;

$fileIn = $ARGV[0];
$fileOut = $ARGV[1];

my %dateHash;

open (my $fhIn, '<', $fileIn) or die "file in error\n";
while (my $lineIn = <$fhIn>){
	($title, $uploader, $dates) = split ("\t", $lineIn);
	@dateArr = split (", ", $dates);
	foreach (@dateArr){
		chomp $_;
		($mm, $dd, $yyyy) = split ("/", $_);
		$schwartzDate = "$yyyy/$mm/$dd";
		push( @{ $dateHash {$schwartzDate} }, "$title : $uploader");
	}
}
close $fhIn;

#foreach $nextItem (@{$dateHash{$key}}){
open (my $fhOut, '>', $fileOut) or die "file out error\n";
foreach my $key (sort keys %dateHash){
	print $fhOut "$key\n\n";
  foreach my $element (@{ $dateHash{$key}}){
	print $fhOut "$element\n\n";
  }
	print $fhOut "***\n";
}
close $fhOut;
