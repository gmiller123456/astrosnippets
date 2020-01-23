#define PI 3.14159265358979323
//From https://observablehq.com/@mourner/sun-position-in-900-bytes

//Date is seconds since Jan 1 1970
//lng and lat are Lat/Lon in Degrees
void getSunPosition (long date, double lng, double lat, double *azimuth, double *altitude) {
  double r = PI / 180;
  double t = date / 315576e4 - 0.3;
  //double t = date / 315576e7 - 0.3;
  double m = r * (357.52911 + t * (35999.05029 - t * 1537e-7));
  double c = cos(r * (125.04 - 1934.136 * t));
  double l = r * (280.46646 + t * (36000.76983 + t * 3032e-7) + (1.914602 - t * (4817e-6 - t * 14e-6)) * sin(m) -
       569e-5 - 478e-5 * c) + (0.019993 - 101e-6 * t) * sin(2 * m) + 289e-6 * sin(3 * m);
  double e = r * (84381.448 - t * (46.815 - t * (59e-5 + 1813e-6 * t))) / 3600 + r * 256e-5 * c;
  double sl = sin(l);
  double cr = cos(r * lat);
  double sr = sin(r * lat);
  double d = asin(sin(e) * sl);
  double h = r * (280.46061837 + 13184999.8983375 * t + lng) - atan2(cos(e) * sl, cos(l));
  double sd = sin(d);
  double cd = cos(d);
  double ch = cos(h);

  *azimuth= (PI + atan2(sin(h), ch * sr - cr * sd / cd))/r;
  *altitude= asin(sr * sd + cr * cd * ch)/r;
}