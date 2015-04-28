#!/usr/bin/perl

# needed to pull from the web
use LWP::Simple;

$fileOut = $ARGV[0];

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
  'UUFKzRzwT28NDxFfxuq1vEmQ',		# DiscoDog Channel
  'UUCiCH4bjwNnxKTy0KmdpXBQ', 		# HeyBuddays
  'UU_JW3s3GEoNIc9bBUnrU8iw', 		# ronandfriendz
  'PLAtxWiJjc0k1yAsHZAd6FWG7MIsrjMQRI', # thebobwhookidsamshow R&F playlist
  'UUDcDSFLXLeC4zwxfsndzLcw', 		# kirkangel
  'PLzKDH2c8Gah0zRGEKQHdzX-3e5SJh0QG0', # Frrrrrrrrunkis R&F playlist
  'UUwTMLRqNN1wOMR8A8gyaLvA', 		# ronscigarBJJ
  'UUNX19MqeH747Rkod6YcjIQw', 		# CK Andersno
  'UUVQyFlFQxuRmI1uw4fCVqfg', 		# ronandfezfans
  'PL8h2eiL0gjh88jO5Dkw6gU_eLdK07sJxa', # neil rogers R&R playlist
  'PLl2sPEno7jw8Uz4X0H-41k3NmSnGAYxGy', # s1nberg R&R playlist
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
	
	my @contentArr = split /\n/, $content;

	# write to fileOut
	open (my $fhOut, '>>', $fileOut) or die "file open error";
	foreach my $row (@contentArr){
		chomp $row;

		if ($row =~ /"title": "(.*)"/){
			print $fhOut "*****\n";
			print $fhOut "T: $1\n";}

		elsif ($row =~ /"description": "(.*)"/){
			print $fhOut "D: $1\n";}

		elsif ($row =~ /"channelTitle": "(.*)"/){
			print $fhOut "U: $1\n";}

		elsif ($row =~ /"videoId": "(.*)"/){
			print $fhOut "L: http://youtube.com/watch?v=$1\n";}
        }
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
		
