

# read entire file into a string
sub slurp {
	my $filename = shift(@_);
	open(my $f, '<', $filename) or die "OPENING $filename: $!\n";
	$string = do { local($/); <$f> };
	close($f);
	return $string;
}

sub strip_comments {
    my $string=shift;
    $string =~ s#/\*.*?\*/##sg; #strip multiline C comments
    return $string;
}

sub outputFileFromTemplate {
	my $templateFilename = shift(@_);
	my $outputFilename = shift(@_);
	my $params = shift(@_);

	$text = slurp($templateFilename);
	foreach $key (keys %$params)
	{
		$text =~ s/\%$key\%/$params->{$key}/;
	}
	
	print "  outputting $outputFilename ...\n";
	open(OUTP, '>' . $outputFilename) or die("Could not open $outputFilename file for writing.");
	print OUTP $text;
	close(OUTP);
}
