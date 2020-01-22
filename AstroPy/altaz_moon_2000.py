from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body_barycentric, get_body, get_moon
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy import units as u
import time;

t = Time("2020-04-11 16:00", scale="utc")
#t2 = Time("2000-01-1 18:00", scale="utc")
loc = EarthLocation(lat=38.2464000*u.deg, lon=274.236400*u.deg, height=0*u.m)
#print(loc )
print(t.sidereal_time('mean', 'greenwich'))

with solar_system_ephemeris.set('jpl'):
  moon = get_body('moon', t, loc)

#print(moon)
print(get_body('moon', t, loc))

altazframe = AltAz(obstime=t, location=loc, pressure=0)
moonaz=moon.transform_to(altazframe)

print(moon.ra.hms, moon.dec.dms)
print(moonaz.alt.degree,moonaz.az.degree)
