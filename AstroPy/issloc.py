import ephem

line1 = "ISS (ZARYA)             "
line2 = "1 25544U 98067A   18196.64935833  .00001077  00000-0  23631-4 0  9990"
line3 = "2 25544  51.6397 236.8437 0003929 319.0136 187.4053 15.53975939122944"

iss = ephem.readtle(line1, line2, line3)
iss.compute()
print('%s %s' % (iss.sublong, iss.sublat))
