from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body_barycentric, get_body, get_moon
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy import units as u
import time;

def p(b):
	print(b.ra.hms, b.dec.dms)


#solar_system_ephemeris.set('jpl')  
t = Time("2000-01-01 00:00", scale="utc")
#t=Time.now();
#85°45'49.0''W, 38°14'47.0''N ( 274.236400,38.2464000) Louisville
#loc = EarthLocation.of_address('louisville, ky') 
loc = EarthLocation(lat=38.2464000*u.deg, lon=274.236400*u.deg, height=0*u.m)

start=time.time();
#with solar_system_ephemeris.set('builtin'):
with solar_system_ephemeris.set('jpl'):
  mer = get_body('mercury', t, loc) 
  ven = get_body('venus', t, loc) 
  mar = get_body('mars', t, loc) 
  jup = get_body('jupiter', t, loc) 
  sat = get_body('saturn', t, loc) 
  ura = get_body('uranus', t, loc) 
  nep = get_body('neptune', t, loc) 
  moon = get_body('moon', t, loc) 
  sun = get_body('sun', t, loc) 
end=time.time();
print(end-start)

print(t)
p(sun)
p(mer)
p(ven)
p(mar)
p(jup)
p(sat)
p(ura)
p(nep)
#p(moon)
