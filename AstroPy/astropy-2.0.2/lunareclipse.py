from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body_barycentric, get_body, get_moon
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy import units as u
import time;

t = Time("2017-09-26 03:00", scale="utc")

solar_system_ephemeris.set('jpl')

earth = get_body_barycentric('earth', t) 
moon = get_body_barycentric('moon', t) 
sun = get_body_barycentric('sun', t) 

print(earth.y);