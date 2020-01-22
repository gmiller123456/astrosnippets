import numpy as np
from astropy import units as u
from astropy.time import Time
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy.coordinates import get_sun


bear_mountain = EarthLocation(lat=41.3*u.deg, lon=-74*u.deg, height=390*u.m)

utcoffset = -4*u.hour
midnight = Time('2012-7-13 00:00:00') - utcoffset
delta_midnight = np.linspace(-2, 7, 100)*u.hour

delta_midnight = np.linspace(-12, 12, 1000)*u.hour
times = midnight + delta_midnight
altazframe = AltAz(obstime=times, location=bear_mountain)
sunaltazs = get_sun(times).transform_to(altazframe)
print(sunaltazs)
#m33altazs = m33.transform_to(altazframe)  