function LocalSideralTime(JD, Longitude){
	var T = (JD - 2451545.0) / 36525;
	var D = (JD - 2451545.0);
	GMST = 18.697374558 + 24.06570982441908 * D
	var LST=GMST+Longitude/15;
	while(LST>24) LST-=24;
	while(LST<0) LST+=24;
	return LST;

	//return Normalize( 280.46061837 + 360.98564736629 * (JD - 2451545.0) + 0.000387933 * T * T - T * T * T / 38710000.0 + Longitude , 360);
}

function getRistSetTransit(JD,lat,lon,RA,dec){
	var h = 0; // degrees: Center of Sun's disk touches a mathematical horizon
	//h = -0.25 degrees: Sun's upper limb touches a mathematical horizon
	//var h = -0.583; // degrees: Center of Sun's disk touches the horizon; atmospheric refraction accounted for
	//var h = -0.833; //degrees: Sun's upper limb touches the horizon; atmospheric refraction accounted for
	//h = -6 degrees: Civil twilight (one can no longer read outside without artificial illumination)
	//h = -12 degrees: Nautical twilight (navigation using a sea horizon no longer possible)
	//h = -15 degrees: Amateur astronomical twilight (the sky is dark enough for most astronomical observations)
	//h = -18 degrees: Astronomical twilight (the sky is completely dark)
	var d = (JD - 2451545.0);
	var M=356.0470 + 0.9856002585 * d;
	var w=282.9404 + 4.70935E-5 * d
	var L=M+w;
	var GMST0=L+180;
	var LST=RA;
	var transit=(RA-GMST0-lon);
	while(transit<0) transit+=360;
	transit/=15.04107;

	h=DegreesToRadians(h);
	lat=DegreesToRadians(lat);
	dec=DegreesToRadians(dec);
	var cosLHA=(Math.sin(h)-Math.sin(lat)*Math.sin(dec))/(Math.cos(lat)*Math.cos(dec));

	var LHA=RadiansToDegrees(Math.acos(cosLHA))/15.04107;

	var t=new Object();
	t.transit=transit;
	t.rise=(transit-LHA);
	t.set=(transit+LHA);
	while(t.transit<0) t.transit+=24;
	while(t.rise<0) t.rise+=24;
	while(t.set<0) t.set+=24;
	while(t.transit>24) t.transit-=24;
	while(t.rise>24) t.rise-=24;
	while(t.set>24) t.set-=24;
	if(cosLHA<-1) {t.rise="Always above horizon"; t.set="Always above horizon";}
	if(cosLHA>1)  {t.rise="Never above horizon"; t.set="Never above horizon";}

	return t;


}

function DegreesToRadians(value) { return value * Math.PI / 180; }

function RadiansToDegrees(value) { return value * 180 / Math.PI; }

function toAltAz(Latitude, Longitude, Dec, RA, JD){
	// 0 : Alt ; 1 : Az
	var results = [ 0, 0 ];
	// get current apparent RA for local time/longitude
	var LST=LocalSideralTime(JD, Longitude)*15;
	var apparentRA = Normalize(LST - RA, 360);
	// get values in radians so the Trig function can be used
	apparentRA = DegreesToRadians(apparentRA);
	Dec = DegreesToRadians(Dec);
	Latitude = DegreesToRadians(Latitude);
	// Alt
	results[0] = Math.asin(Math.sin(Dec) * Math.sin(Latitude) + Math.cos(Dec) * Math.cos(Latitude) * Math.cos(apparentRA));
	// if alt != 0 then get AZ else AZ = 0 (object exactly at zenith)
	results[1]=0;
	//if(results[0] != 0) Math.acos((Math.sin(Dec) - Math.sin(results[0]) * Math.sin(Latitude)) / (Math.cos(results[0]) * Math.cos(Latitude)));
	if(results[0] != 0){
		results[1]=Math.acos((Math.sin(Dec) - Math.sin(results[0]) * Math.sin(Latitude)) / (Math.cos(results[0]) * Math.cos(Latitude)));
	}

	// translate back to degrees
	results[0] = RadiansToDegrees(results[0]);
	results[1] = RadiansToDegrees(results[1]);
	// change hemisphere
	if (Math.sin(apparentRA) > 0) results[1] = 360 - results[1];
	return results;

}

function Normalize(value, norm){
	value = (value/norm - Math.floor(value/norm)) * norm;
	return (value < 0) ? norm + value : value;
}

function Cartisian2Polar(p){
	r=Math.sqrt(p.x*p.x+p.y*p.y+p.z*p.z);
	o=Math.acos(p.z/r);
	l=Math.atan2(p.y,p.x);

	var temp=new Object();

	temp.dec=-(o*180/Math.PI-90);
	temp.ra=l*180/Math.PI;
	return temp;
}

function toGeocentric(planets){
	for(var i=0;i<9;i++){
    	if(i!=3) sub(planets[i],planets[3]);
	}
	sub(planets[3],planets[3]);
}

function sub(p1,p2){
	p1.x-=p2.x;
	p1.y-=p2.y;
	p1.z-=p2.z;
}

function pdhms(deg){
	var t=deg;
	if(t<0) t+=360;
	t=t/360.0*24.0
	var h=Math.floor(t);
	t-=h;
	var m=Math.floor(t*60.0);
	t=t*60-m;
	var s=Math.floor(t*60*100)/100;

	return h+"h"+m+"m"+s+"s";
}

function phms(deg){
	var t=deg;
	if(t<0)t+=24;
	var h=Math.floor(t);
	t-=h;
	var m=Math.floor(t*60.0);
	t=t*60-m;
	var s=Math.floor(t*60*100)/100;

	return h+"h"+m+"m"+s+"s";
}

function pdms(deg){
	var t=deg;
	var sign="";
	if(t<0) sign="-";
	t=Math.abs(t);
	var d=Math.floor(t);
	t-=d;
	var m=Math.floor(t*60.0);
	t=t*60-m;
	var s=Math.floor(t*60*100)/100;

	return sign+d+"h"+m+"m"+s+"s";
}
