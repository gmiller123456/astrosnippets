from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body_barycentric, get_body, get_moon
#t = Time("2017-09-25 20:26")
loc = EarthLocation.of_address('louisville, ky') 
with solar_system_ephemeris.set('builtin'):
  sat = get_body('saturn', Time.now(), loc) 
  moon = get_body('moon', Time.now(), loc) 

print(sat.ra.hms)
print(moon.ra.hms)
