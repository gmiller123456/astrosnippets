from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body_barycentric, get_body, get_moon
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy import units as u
import time;

#solar_system_ephemeris.set('jpl')  
t = Time("2017-09-26 03:00", scale="utc")
#t=Time.now();
#85°45'49.0''W, 38°14'47.0''N ( 274.236400,38.2464000) Louisville
#loc = EarthLocation.of_address('louisville, ky') 
loc = EarthLocation(lat=38.2464000*u.deg, lon=274.236400*u.deg, height=0*u.m)

start=time.time();
#with solar_system_ephemeris.set('builtin'):
with solar_system_ephemeris.set('jpl'):
  sat = get_body('saturn', t, loc) 
  moon = get_body('moon', t, loc) 
  sun = get_body('sun', t, loc) 
end=time.time();
print(end-start)


altazframe = AltAz(obstime=t, location=loc, pressure=0)
moonaz=moon.transform_to(altazframe)
sataz=sat.transform_to(altazframe)
sunaz=sun.transform_to(altazframe)

print(t)
print(sat.ra.hms, sat.dec.dms)
print(sataz.alt.degree,sataz.az.degree)
print((sataz.alt.degree-5.5792)*60*60, (sataz.az.degree-236.0417)*60*60)
print(moonaz.alt.degree,moonaz.az.degree)
print((moonaz.alt.degree-0.6235)*60*60, (moonaz.az.degree-246.4587)*60*60)
print(sunaz.alt.degree,sunaz.az.degree)
print((sunaz.alt.degree+38.8594)*60*60, (sunaz.az.degree-306.7623)*60*60)


#Saturn
#********************************************************************************************************************************
# Date__(UT)__HR:MN     R.A._(ICRF/J2000.0)_DEC Azi_(a-appr)_Elev  APmag  S-brt            delta      deldot    S-O-T /r    S-T-O
#********************************************************************************************************************************
#$$SOE
#2017-Sep-26 03:00  m  17 24 19.40 -22 05 59.1 236.0417   5.5792   1.43   7.19 10.2096597922252  28.4984535  78.7618 /T   5.6079

#Moon
#2017-Sep-26 03:00  m  16 38 45.10 -17 50 33.9 246.4587   0.6235  -9.07   5.66 0.00269659959193   0.3422153  67.7334 /T 112.1239
#Sun
#2017-Sep-26 03:00  m  12 10 57.08 -01 11 16.0 306.7623 -38.8594 -26.74 -10.59 1.00264150047543  -0.2720132   0.0000 /?   0.0000