#!/usr/bin/perl
#************************************************************************
# Translate STARS simulation JSON into a C++ file
# - A. O'Brien 
#************************************************************************

use JSON::Parse 'parse_json';
use Data::Dumper;

#do './subroutines.pl';

# parse command-line arguments

my ($filename_input, $filename_output) = @ARGV;
 
if (not defined $filename_input) {
  die "Need input filename\n";
}
 
if (not defined $filename_output) {
  die "Need output filename\n";
}

# input JSON file

$json = slurp($filename_input);
$h = parse_json($json);

#print Dumper($h);
#exit;

#************************************************************************
# Create the C++ code for the satellite hardware description
#************************************************************************

$str = '';

$str .= '  DataProcessorTemplate processor;' . "\n";
$str .= '  Battery battery(0.9333, 6, 12.9, 85);' . "\n";
$str .= '  SolarPanel panel(29, 0.06, 0, 0, 0, &sun);' . "\n";
$str .= '  SubsystemPower power_ss(battery, {panel, panel}, 6.2425);' . "\n";
$str .= '  AntennaDipole comm_antenna(30, 0, 0, 0);' . "\n";
$str .= '  comm_antenna.Log("output/antenna.nc4");' . "\n";
$str .= '  ModemUhfDeploy uhf_modem;' . "\n";
$str .= '  SubsystemComm comm(&comm_antenna, &uhf_modem);' . "\n";
$str .= '  AntennaHelical sensing_antenna(30, 0, 0, 0);' . "\n";
$str .= '  SensorCloudRadar cloud_radar("input/nc4/", 10);' . "\n";
$str .= '  SubsystemSensing cloud(&sensing_antenna, &cloud_radar);' . "\n";
$str .= "\n";


# "simulation_settings": {
#    "kSecondsPerTick": 1,
#    "kNumTicks": 3600
# }

$KNUMTICKS = $h->{'simulation_settings'}->{'kNumTicks'};
$KSECONDSPERTICK = $h->{'simulation_settings'}->{'kSecondsPerTick'};
  
    
# TODO: check satellites

# loop over each satellite constellation

$sats = $h->{'satellites'};
$c = 0;

foreach $sat (@$sats) {

        $label = $sat->{'label'};
	$str .= "  // $label\n";
	
	
		if( exists $sat->{'orbit_tle_file'} )
		{
				$is_orbit_tle_string = 0;
				$is_orbit_generator = 0;
				$orbit = $sat->{'orbit_tle_file'};
		}
		
		if( exists $sat->{'orbit_tle'} )
		{
				$is_orbit_tle_string = 1;
				$is_orbit_generator = 0;
				$orbit = $sat->{'orbit_tle'};
		}
		
		if( exists $sat->{'orbit_generator'} )
		{
				$is_orbit_tle_string = 0;
				$is_orbit_generator = 1;
				$orbit = $sat->{'orbit_generator'};
		}
		
		if( exists $sat->{'orbit_generator_from_tle'} )
		{
				$is_orbit_tle_string = 1;
				$is_orbit_generator = 1;
				$orbit = $sat->{'orbit_generator_from_tle'};
		}
		
		if( not defined $orbit )
		{
			$is_orbit_tle_string = 1;
			$is_orbit_generator = 0;
				
			# default to ISS orbit
			$orbit = { 'tle_label' => 'ISS (default)', 
			'tle' => [ '1 25544U 98067A   21009.85938488  .00001675  00000-0  38168-4 0  9994',
				'2 25544  51.6464  45.8515 0000514 205.2264 333.5747 15.49275141264055'] };
		}
				
		if( $is_orbit_tle_string )
		{
			# source is tle string
		
			$tle_label = $orbit->{'tle_label'};
			$tle_line1 = $orbit->{'tle'}->[0];
			$tle_line2 = $orbit->{'tle'}->[1];
			
			$tle_index = [ ];
			
			$str .= "  // $tle_label\n";
			$str .= "  std::array<std::string, 3> tle_$c = {\"$tle_label\",\n";
			$str .= "    \"$tle_line1\",\n";
			$str .= "    \"$tle_line2\"};\n";
			$str .= "  PlatformOrbit p_$c = PlatformOrbit(tle_$c);\n";
			
		}
		else
		{
			# source is tle file
			$tle_path = $orbit->{'tle_path'};
			$tle_index = $orbit->{'tle_index'}; # array ref
			
			$str .= "  std::string tle_path_$c = \"$tle_path\";\n";
			$str .= "  std::vector<PlatformOrbit> pl_$c = PlatformOrbitList(tle_path_$c);\n";
			
			@tmp = ();
			foreach $index (@$tle_index){
				push @tmp, "p_" . "$c" . "[$index]";	
			}
			if( (scalar @tmp) <= 1 )
			{
				$str .= "  PlatformOrbit p_$c = pl_" . $c . "[0];\n";
			}
		}
		
		if( $is_orbit_generator )
		{
			$d1 = $orbit->{'orbit_planes'};
			$d2 = $orbit->{'groups_per_plane'};
			$d3 = $orbit->{'sats_in_train'};
			$d4 = $orbit->{'sats_in_tandem'};
			$d5 = $orbit->{'train_angle'};
			$d6 = $orbit->{'tandem_angle'};
		
			$str .= "  std::vector<PlatformOrbit> c_$c = p_$c.Duplicate($d1, $d2, $d3, $d4, $d5, $d6);\n";
		}
		else
		{
			
			@tmp = ();
			foreach $index (@$tle_index){
				push @tmp, "pl_" . "$c" . "[$index]";	
			}
			
			if( (scalar @tmp) == 0 )
			{
				$str .= "  std::vector<PlatformOrbit> c_$c = { p_$c };\n";
			}
			elsif( (scalar @tmp) == 1 )
			{
				$str .= "  std::vector<PlatformOrbit> c_$c = { p_$c };\n";
			}
			else{
				$tmp_str = join(',',@tmp);
				$str .= "  std::vector<PlatformOrbit> c_$c = {$tmp_str};\n";
			}
		}
		
		$str .= "  system.Launch(c_$c, $c, false, comm, cloud, power_ss, \&processor, \&data_log);\n";
		$str .= "\n";

	$c++;
	
}

print "$str\n";

#************************************************************************
# Create the C++ code for the satellite hardware description
#************************************************************************

#$str .= "DataProcessorTemplate processor;\n";

# create antennas
#$str .= "AntennaDipole comm_antenna(30, 0, 0, 0);\n";
#$str .= "AntennaHelical sensing_antenna(30, 0, 0, 0);\n";
  
# create power subsystem
#$str .= "Battery battery(0.9333, 6, 12.9, 85);\n";
#$str .= "SolarPanel panel(29, 0.06, 0, 0, 0, &sun);\n";
#$str .= "SubsystemPower power_ss(battery, {panel, panel}, 6.2425);\n";

# create comm subsystem
#$str .= "comm_antenna.Log(\"output/antenna.nc4\");\n";
#$str .= "ModemUhfDeploy uhf_modem;\n";
#$str .= "SubsystemComm comm(&comm_antenna, &uhf_modem);\n";

# create sensor subsystem
#$str .= "SensorCloudRadar cloud_radar(\"input/nc4/\", 10);\n";
#$str .= "SubsystemSensing cloud(&sensing_antenna, &cloud_radar);\n";

# create orbits
#$str .= "std::string tle_path = \"input/tle/cubesat.tle\";\n";
#$str .= "std::vector<PlatformOrbit> orbits = PlatformOrbitList(tle_path);\n";
#$str .= "std::vector<PlatformOrbit> first = {orbits[0]};\n";

# create complete observing system
#$str .= "system.Launch(first, 0, true, comm, cloud, power_ss, &processor, &data_log);\n";

#************************************************************************
# Insert code into template and output stars.cc file
#************************************************************************

#$templateFilename = 'stars.template';
$templateFilename = '/translator/stars.template';
$outputFilename = $filename_output; #'stars.cpp';
$params{'SATELLITE_HARDWARE'} = $str;
$params{'KNUMTICKS'} = $KNUMTICKS;
$params{'KSECONDSPERTICK'} = $KSECONDSPERTICK;


outputFileFromTemplate($templateFilename, $outputFilename, \%params);


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
