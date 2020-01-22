import numpy as np
from astropy import units as u
from astropy.time import Time
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
m33 = SkyCoord.from_name('M33')  
bear_mountain = EarthLocation(lat=41.3*u.deg, lon=-74*u.deg, height=390*u.m)
utcoffset = -4*u.hour  # Eastern Daylight Time
time = Time('2012-7-12 23:00:00') - utcoffset
m33altaz = m33.transform_to(AltAz(obstime=time,location=bear_mountain))  
print("M33's Altitude = {0.alt:.2}".format(m33altaz))