#!/usr/bin/perl
use strict;

open(my $f,"D:\\JPL DE\\ascii\\de431\\testpo.431");

while(my $l=<$f>){
	my $year=substr($l,3,6)-0;
	my $mon=substr($l,10,2)-0;
	my $day=substr($l,13,2)-0;
	my $jd=substr($l,15,10);
	print "test($year, $mon, $day, $jd); //$l";
}