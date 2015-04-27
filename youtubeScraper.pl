#!/usr/bin/perl

# needed to pull from the web
use LWP::Simple;

$fileOut = "test.txt";

# gets googleapi key, from keyFile.txt in current dir
my $keyFile = "keyFile.txt";
open (my $fh, "<", $keyFile) or die "Couldn't open keyFile";
while (my $row = <$fh>){
	chomp $row;
	$key = $row;
}
close $fh;


# channels/playlists
my @playlists = (
	'UUFKzRzwT28NDxFfxuq1vEmQ',	#DiscoDog Channel
);

# for each playlist, get data and do it recursively via subs below
foreach(@playlists){
	$currPL = $_;
	my $url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$currPL&key=$key";
	&getContent($url);
}

# gets output of googleapi queries
sub getContent{
	$url = $_[0];
	my $content = (get $url);
	die "Couldn't get $url" unless defined $content;
	
	# write to fileOut
	open (my $fhOut, '>>', $fileOut) or die "file open error";
		print $fhOut "$content\n";
	close $fhOut;

	# get more pages if nextPageToken exists
	&getMore($content);
}

# gets output of googleapi queries, only 50 results per page
sub getMore{
	my $content = $_[0];
	if ($content =~ /"nextPageToken": "(\w*)"/gm){
		my $nextPage = $1;
		my $url = "https://www.googleapis.com/youtube/v3/playlistItems?pageToken=$nextPage&part=snippet&maxResults=50&playlistId=$currPL&key=$key";
		&getContent($url);
	}
}
		
