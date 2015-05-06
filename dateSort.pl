#!/usr/bin/perl

#command line $perl dateSort.pl fileToBeSorted fileToBeWritten formattedFile
$fileIn = $ARGV[0];
$fileOut = $ARGV[1];
$fFileOut = $ARGV[2];

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
		push( @{ $dateHash {$schwartzDate} }, "$title\n$uploader [$views views / $likes likes]\n$link [$length]\n");
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
	print $fhOut "***\n$fKey\n";

  foreach my $element (@{ $dateHash{$key}}){

	#print bits
	print $fhOut "$element\n";
  }
	
}
close $fhOut;

# prints wiki formatting
$yearCount = 1999;
$monthCount = 11;

my @months = qw(month January February March April May June July August September October November December);

open (my $fhIn, '<', $fileOut) or die "file in error\n";
open (my $fhOut, '>', $fFileOut) or die "final file out error\n";

# float table of contents to rights
print $fhOut "{{tocright}}\n";

while (my $row = <$fhIn>){
	chomp $row;
	if ($row eq '***'){
		$nextRowDate = 1;
		next;
	}
	if ($nextRowDate == 1){
		
		# next row won't be a date
		$nextRowDate = 0;

		($yyyy, $mm, $dd) = split ("/", $row);

		# push year header
		if ($yyyy > $yearCount){
			print $fhOut "=='''$yyyy'''==\n";
			$yearCount++;
			$monthCount = 0;
		}

		# creates month subheaders
		if ($mm > $monthCount){
			print $fhOut "==='''$months[$mm]'''===\n";
			$monthCount = $mm;
		}
		
		print $fhOut "'''$row'''\n";
		next;
	}

	print $fhOut "$row<br>\n";
}
