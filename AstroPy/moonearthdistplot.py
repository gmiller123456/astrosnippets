import numpy as np
import matplotlib.pyplot as plt
from astropy.time import Time
from astropy.time import TimeDelta
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body_barycentric, get_body, get_moon
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy import units as u
import math;
import numpy as np;
import datetime

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

def pointLineDistance(x0,x1,x2):
	n=length(cross(np.subtract(x0,x1),np.subtract(x0,x2)))
	d=length(np.subtract(x2,x1))
	return n/d

def scale(v,x):
	return [v[0]*x,v[1]*x,v[2]*x];

def computeItteration(t):
	global best
	global besttime
	global totalstart
	global totalend
	earth = get_body_barycentric('earth', t) 
	moon = get_body_barycentric('moon', t) 
	sun = get_body_barycentric('sun', t) 

	earth=earth-sun;
	moon=moon-sun;
	sun=sun-sun;

	ex.append(earth.x/u.km)
	ey.append(earth.y/u.km)
	mx.append(moon.x/u.km)
	my.append(moon.y/u.km)
	sx.append(sun.x/u.km)
	sy.append(sun.y/u.km)

	e=normal(vector(earth));
	d=vector(moon);

	p=pointLineDistance(d,[0,0,0],vector(earth))
	points.append(p)
	if(p<best):
		best=p
		besttime=t

	if(totalstart is None):
		if(p<3474/2): #wrong, just needs to be inside umbra, not close to sun/earth line
			totalstart=t

	if(totalstart is not None):
		if(p>3474/2): #wrong, just needs to be inside umbra, not close to sun/earth line
			totalend=t;

solar_system_ephemeris.set('jpl')

ex=[]
ey=[]
mx=[]
my=[]
sx=[]
sy=[]
points=[]
t = Time("2019-01-21 0:10", scale="utc")
best=100000;
besttime=t
totalstart=None;
totalend=None;

for x in range(2000):
	t=t+TimeDelta(60,format="sec")
	computeItteration(t);

#plt.scatter(ex,ey)
#plt.scatter(mx,my)
#plt.scatter(sx,sy)
plt.plot(points)
plt.show()

print(besttime)
print(totalstart)
print(totalend)