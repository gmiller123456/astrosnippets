//***Dave Yeap****
//var time = 0.1633576; // 2 May 2016 Julian Emphemeris Date (Teph) =  2457510.5

//                               a           e           I            L         Lomega         Pomega
//                              AU          rad         deg          deg          deg           deg

var elements =         [    0,         0,           0,         0,             0,            0,      // sun
                            0.38709927, 0.20563593, 7.00497902, 252.25032350, 77.45779628, 48.33076593, //mercury
                            0.72333566, 0.00677672, 3.39467605, 181.97909950, 131.60246718, 76.67984255, //venus
                            1.00000261, 0.01671123, -0.00001531, 100.46457166, 102.93768193, 0.0, //earth moon barycenter
                            1.52371034, 0.09339410, 1.84969142, -4.55343205, -23.94362959, 49.55953891, //mars
                            5.20288700, 0.04838624, 1.30439695, 34.39644051, 14.72847983, 100.47390909, //jupiter
                            9.53667594, 0.05386179, 2.48599187, 49.95424423, 92.59887831, 113.66242448, //saturn
                            19.18916464, 0.04725744, 0.77263783, 313.23810451, 170.95427630, 74.01692503, //uranus
                            30.06992276, 0.00859048, 1.77004347, -55.12002969, 44.96476227, 131.78422574,]; //neptune
                            
//                         AU/Cy         rad/Cy       deg/Cy      deg/Cy          deg/Cy      deg/Cy
var rates =         [      0,         0,           0,           0,              0,          0,
                         0.00000037,  0.00001906, -0.00594749, 149472.67411175,0.16047689, -0.12534081,  //mercury
                         0.00000390, -0.00004107, -0.00078890, 58517.81538729, 0.00268329, -0.27769418,  //venus
                         0.00000562, -0.00004392, -0.01294668, 35999.37244981, 0.32327364,  0.0,         //earth moon barycenter
                         0.00001847,  0.00007882, -0.00813131, 19140.30268499, 0.44441088, -0.29257343,  //mars
                        -0.00011607, -0.00013253, -0.00183714, 3034.74612775,  0.21252668,  0.20469106,  //jupiter
                        -0.00125060, -0.00050991,  0.00193609, 1222.49362201, -0.41897216, -0.28867794,  //saturn
                        -0.00196176, -0.00004397, -0.00242939, 428.48202785,   0.40805281,  0.04240589,  //uranus
                         0.00026291,  0.00005105,  0.00035372, 218.45945325,  -0.32241464, -0.00508664,];  //neptune
                       


var planets = new Array(); // position of planets in X
var pltsX = new Array(); // position of planets in Y
var pltsZ = new Array(); // position of planets in Z   

var sin=function(x){return Math.sin(x);};
var cos=function(x){return Math.cos(x);};
var sqrt=function(x){return Math.sqrt(x);};
var PI=Math.PI;


function julianDay(d){
  return (d.valueOf() / (1000 * 60 * 60 * 24)) - 0.5 + 2440588;
}

function computeAll(date) {
  var t = (julianDay(date) - 2451545) / 36525;

  var start=window.performance.now();
  for (var i = 0; i < 9; i++) {
    planets[i] = PositionPS(i, t);
  }
  var end=window.performance.now();
  console.log(end-start);
  
  planets[0].color="yellow";
  planets[1].color="red";
  planets[2].color="blue";
  planets[3].color="#00ffff";
  planets[4].color="red";
  planets[5].color="brown";
  planets[6].color="white";
  planets[7].color="green";
  planets[8].color="blue";

}

function PositionPS(PPs, time) {

  // computing  the six keplerian's elements
  var a = elements[6*PPs+0] + rates[6*PPs+0]*time;    //  semi_major_axis
  var e = (elements[6*PPs+1] + rates[6*PPs+1]*time);    //  eccentricity
  var I = elements[6*PPs+2] + rates[6*PPs+2]*time;    //  inclination
  var L = elements[6*PPs+3] + rates[6*PPs+3]*time;    //  mean_longitude
  var Lomega = elements[6*PPs+4] + rates[6*PPs+4]*time;    //  longitude of perihelion
  var Pomega = elements[6*PPs+5] + rates[6*PPs+5]*time;    //  longitude of the ascending node


  // compute the argument of perihelion, omega and the mean anomaly M:
  var  omega = Lomega -  Pomega;
  var M = L - Lomega;  //Note when using the 3000BC - 3000AD elements this needs an additional 3 terms

  while (M > 180) M -=360;
  //btain the eccentric anomaly, E, from the solution of Kepler’s equation
  var E = M + (58.29578*e) * sin(M*PI/180); //E0
  for (var i = 0; i < 5; i++) {  // iterate for precision, 10^(-6) degrees is sufficient
    E = KeplersEquation(E, M, e);
  }

  //planets holiocentric coordinates in its orbital plane r', with
  //x - axis aligned from the focus to the perihelion.
  omega = omega * PI/180;
  E = E * PI/180;
  I = I * PI/180;
  Pomega = Pomega * PI/180;
  var Xprime = a * (cos(E)-e);
  var Yprime = a * sqrt((1-e*e))*sin(E);

  // compute the coordinates in the J2000 ecliptic plane, with the x-axis aligned toward the equinox:
  var ePlaneXYZ = new Object();
  ePlaneXYZ.x = (cos(omega)*cos(Pomega) - sin(omega)*sin(Pomega)*cos(I) )*Xprime + ( -sin(omega)*cos(Pomega) - cos(omega)*sin(Pomega)*cos(I) )*Yprime ;
  ePlaneXYZ.y = (cos(omega)*sin(Pomega) + sin(omega)*cos(Pomega)*cos(I) )*Xprime + ( -sin(omega)*sin(Pomega) + cos(omega)*cos(Pomega)*cos(I) )*Yprime ;
  ePlaneXYZ.z = (sin(omega)*sin(I))*Xprime + (cos(omega)*sin(I))*Yprime;
  return ePlaneXYZ;
}

function KeplersEquation(E,  M, e)
{
  var dM = M - (E - (e * 180/PI )* sin(E*PI/180));
  var dE = dM / (1 - e*cos(E*PI/180));
  return E + dE;
}
