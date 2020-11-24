#!/usr/bin/perl
#************************************************************************
# Translate STARS simulation JSON into a C++ file
# - A. O'Brien 11/3/2020
#************************************************************************

#use JSON;
use JSON::Parse 'parse_json';
use Data::Dumper;

do './subroutines.pl';

$json = '{"a":1,"b":2,"c":3,"d":4,"e":5}';

$text = parse_json($json);
print  Dumper($text);

#************************************************************************
# Create the C++ code for the satellite hardware description
#************************************************************************

$str .= "DataProcessorTemplate processor;\n";

# create antennas
$str .= "AntennaDipole comm_antenna(30, 0, 0, 0);\n";
$str .= "AntennaHelical sensing_antenna(30, 0, 0, 0);\n";
  
# create power subsystem
$str .= "Battery battery(0.9333, 6, 12.9, 85);\n";
$str .= "SolarPanel panel(29, 0.06, 0, 0, 0, &sun);\n";
$str .= "SubsystemPower power_ss(battery, {panel, panel}, 6.2425);\n";

# create comm subsystem
$str .= "comm_antenna.Log(\"output/antenna.nc4\");\n";
$str .= "ModemUhfDeploy uhf_modem;\n";
$str .= "SubsystemComm comm(&comm_antenna, &uhf_modem);\n";

# create sensor subsystem
$str .= "SensorCloudRadar cloud_radar(\"input/nc4/\", 10);\n";
$str .= "SubsystemSensing cloud(&sensing_antenna, &cloud_radar);\n";

# create orbits
$str .= "std::string tle_path = \"input/tle/cubesat.tle\";\n";
$str .= "std::vector<PlatformOrbit> orbits = PlatformOrbitList(tle_path);\n";
$str .= "std::vector<PlatformOrbit> first = {orbits[0]};\n";

# create complete observing system
$str .= "system.Launch(first, 0, true, comm, cloud, power_ss, &processor, &data_log);\n";

#************************************************************************
# Insert code into template and output stars.cc file
#************************************************************************

$templateFilename = 'stars_template.cpp';
$outputFilename = 'stars.cpp';
$params{'SATELLITE_HARDWARE'} = $str;

outputFileFromTemplate($templateFilename, $outputFilename, \%params);
