from astropy.time import Time,TimeDelta
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body_barycentric, get_body, get_moon
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy import units as u
import time;
import math;

def normal(v):
	x=v[0];
	y=v[1];
	z=v[2];
	l=math.sqrt(x*x+y*y+z*z);
	t=[x/l,y/l,z/l];
	return t;

def vector(v):
	x=v.x/u.km;
	y=v.y/u.km;
	z=v.z/u.km;
	return [x,y,z]

def length(v):
	return math.sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);

def dt(v1,v2):
	return v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2];

def cross(v1,v2):
	x=v1[1]*v2[2]-v1[2]*v2[1]
	y=v1[2]*v2[0]-v1[0]*v2[2]
	z=v1[0]*v2[1]-v1[1]*v2[0]
	return [x,y,z]

def test(sun,moon):

	aukm=1.496e+8;
	Req = 6378.14 # km.  Equitorial radius of Earth
	Rm = 1738.1 #km. radius of moon
	Rs = 696000.0 #km radius of Sun
	Dm = length(moon);
	Ds = length(sun);
	Um = normal(moon)
	Us = normal(sun)

	# compute semidiameter of the moon and sun
	Sm = math.asin(Rm / Dm);
	Ss = math.asin(Rs / Ds);

	# calculate penumbra shadow angle
	PIm = math.asin(Req / Dm);
	PIs = math.asin(Req / Ds);
	PIl=0.99834*PIm #Corrected parallax
	f1 = 1.02 * (PIl + PIs + Ss);

	# compute umbra shadow angle
	uangle = 1.02 * (PIm + PIs - Ss);

	# compute separation angle between anti-sun and moon vectors
	cpsi = dt(Us,Um);
	psi = math.acos(-cpsi);

	# compute objective function
	fx = psi - f1 - Sm;

	penumbral=1.02*(PIl+PIs+Ss)+Sm;
	partial  =1.02*(PIl+PIs-Ss)+Sm;
	total    =1.02*(PIl+PIs-Ss)-Sm;

	state="None";
	if(psi<total):
		state="Total";
	elif(psi<partial):
		state="Partial";
	elif(psi<penumbral):
		state="Penumbral";

	return state;


solar_system_ephemeris.set('jpl')

t = Time("2019-01-21 0:00:00", scale="utc")
interval=TimeDelta(10.0,format='sec')
lightTime=TimeDelta(499,format='sec')
lastState='none'
for x in range(6*24*60*60):

	t=t+interval

	earth = get_body_barycentric('earth', t) 
	moon = get_body_barycentric('moon', t) 
	sun = get_body_barycentric('sun', t-lightTime) 

	sun=vector(sun-earth);
	moon=vector(moon-earth);
	earth=earth-earth;
	state=test(sun,moon)

	if(state!=lastState):
		print(t.iso)
		print(state)
		lastState=state

