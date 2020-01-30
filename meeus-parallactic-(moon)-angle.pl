#!/usr/bin/perl

#Meeus 14.1
#tan q = (sin H)/(tan(lat)*cos(dec)-sin(dec)*cos(H))
#H = hour angle of moon
#lat = observer latitude
#dec = moon declination

#All input/output in RADIANS!
sub getAngle{
	my $H=shift;
	my $lat=shift;
	my $dec=shift;

	my $num=sin($H);
	my $den=(tan($lat)*cos($dec)-sin($dec)*cos($H));

	if($den==0){return 0;}
	return atan2($num,$den);

}