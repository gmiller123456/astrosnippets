
import ephem

def printp(s,p):
	p.compute(louisville);
	#print(s,ephem.localtime(louisville.next_transit(p)))	
	print(s,ephem.localtime(louisville.next_rising(p)),ephem.localtime(louisville.next_transit(p)),ephem.localtime(louisville.next_setting(p)))	
	print(s,p.a_ra,p.a_dec);

louisville = ephem.Observer()
louisville.lat = '38.2527'
louisville.lon = '-85.7585'
#louisville.date = "2000/01/01 00:00"
louisville.date = "2018/11/29 17:18"
louisville.pressure = 0
#louisville.horizon = '-0:34'
print(louisville.epoch)

printp("Sun",ephem.Sun());
printp("Mer",ephem.Mercury());
printp("Ven",ephem.Venus());
printp("Mar",ephem.Mars());
printp("Jup",ephem.Jupiter());
printp("Sat",ephem.Saturn());
printp("Ura",ephem.Uranus());
printp("Nep",ephem.Neptune());
printp("Plu",ephem.Pluto());
printp("Moo",ephem.Moon());

rigel = ephem.star('Vega')
print('%s %s' % (rigel._ra, rigel._dec))
print("rigel",ephem.localtime(louisville.next_rising(rigel)),ephem.localtime(louisville.next_transit(rigel)),ephem.localtime(louisville.next_setting(rigel)))	

wtfstar = ephem.FixedBody()
wtfstar._ra="0";
wtfstar._dec="0";
print('%s %s' % (wtfstar._ra, wtfstar._dec))
print("1,1 ",(louisville.next_rising(wtfstar)),(louisville.next_transit(wtfstar)),(louisville.next_setting(wtfstar)))	
