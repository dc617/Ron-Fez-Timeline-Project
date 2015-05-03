#!/usr/bin/perl

#command line $perl dateSort.pl fileToBeSorted fileToBeWritten
$fileIn = $ARGV[0];
$fileOut = $ARGV[1];

my %dateHash;

open (my $fhIn, '<', $fileIn) or die "file in error\n";
while (my $lineIn = <$fhIn>){
	
	#assuming tab delimited
	($uploader, $title, $length, $likes, $views, $favorites, $link, $thumbnail, $airdates) = split ("\t", $lineIn);

	$airdates =~ s/[\x0A\x0D]//g;
		
	#put dates in array
	@dateArr = split (", ", $airdates);
	foreach (@dateArr){
		chomp $_;
		
		#make Schwartz date
		($mm, $dd, $yyyy) = split ("/", $_);
		$mm = sprintf("%.2d", $mm);
		$schwartzDate = "$yyyy"."$mm"."$dd";

		print "$shwartzDate";

		#add bit to date
		push( @{ $dateHash {$schwartzDate} }, "$title [$length]\n$uploader [$views views / $likes likes]\n$link\n");
	}
}
close $fhIn;

#removes ? dates
delete $dateHash{"00"};

open (my $fhOut, '>', $fileOut) or die "file out error\n";
foreach my $key (sort {$a<=>$b} keys %dateHash){
	$fKey = $key;
	substr ($fKey, 4, 0,"/");
	substr ($fKey, 7, 0,"/");
	print $fhOut "***\n$fKey\n\n";

  foreach my $element (@{ $dateHash{$key}}){

	#print bits
	print $fhOut "$element\n\n";
  }
	
}
close $fhOut;
