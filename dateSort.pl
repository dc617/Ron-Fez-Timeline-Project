#!/usr/bin/perl

#command line $perl dateSort.pl fileToBeSorted fileToBeWritten
$fileIn = $ARGV[0];
$fileOut = $ARGV[1];

my %dateHash;

open (my $fhIn, '<', $fileIn) or die "file in error\n";
while (my $lineIn = <$fhIn>){

	#assuming tab delimited
	($title, $uploader, $dates) = split ("\t", $lineIn);

	#put dates in array
	@dateArr = split (", ", $dates);
	foreach (@dateArr){
		chomp $_;
		
		#make Schwart date
		($mm, $dd, $yyyy) = split ("/", $_);
		$schwartzDate = "$yyyy/$mm/$dd";

		#add bit to date
		push( @{ $dateHash {$schwartzDate} }, "$title : $uploader");
	}
}
close $fhIn;

open (my $fhOut, '>', $fileOut) or die "file out error\n";
foreach my $key (sort keys %dateHash){

	#print date
	print $fhOut "$key\n\n";
  foreach my $element (@{ $dateHash{$key}}){

	#print bits
	print $fhOut "$element\n\n";
  }
	
	#date spacer
	print $fhOut "***\n";
}
close $fhOut;
