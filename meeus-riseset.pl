#!/usr/bin/perl

#Center of body H=0
#cos H0=-tan(lat)*tan(dec)    Meeus P101

#Typically add 34 arcmin for refraction
#Typically add 16 arcmin for sun/moon upper limb

#L=longitude (positive West)
#l=lattitude
#dT=TD-UT
#h0="standard" altitude (e.g. 0+refraction for a star, 16 arcmin+refraction for sun/moon)

#D=date
#ra1/dec1 = RA/DEC on D-1 at midnight
#ra2/dec2 = RA/DEC on D
#ra3/dec3 = RA/DEC on D+1

#S0= sidereal time at midnight UT on D

#cos H0=(sin(h0)-sin(lat)*sin(dec2))/(cos(lat)*cos(dec2))    Meeus 15.1

#verify "second member" between -1 and +1

#Meeus 15.2
#transit = m0=(dec2 + L + S)/360
#rising = m1=m0-(H0/360)
#setting = m2=m0+(H0/360)

#m values are times on day D expressed in fractions of a day

#compute GMST in degrees:
#theta0=S0+360.985647*m (for each m1,m2,m3)

#compute hour angle
#H=theta0 - L - RA

#compute altitude h using eq 13.6
#sin h = sin(lat)*sin(dec) + cos(lat)*cos(dec)*cos(H)

#delta m for transit:
#dm= - H/360

#delta m for rise/set

#dm=(h-h0)/(360*cos(dec)*cos(lat)*sin(H))    #in degrees