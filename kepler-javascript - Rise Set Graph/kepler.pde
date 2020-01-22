//********************************************************************************************************
//A simple solar system simulation, the planet position is solved by using the keplerian elements.
//
//
//
//***Dave Yeap****
//********************************************************************************************************

//import peasy.test.*;
//import peasy.org.apache.commons.math.*;
//import peasy.*;
//import peasy.org.apache.commons.math.geometry.*;
//
//PeasyCam cam;

// (Teph - 2451545.0)/36525 = time
float time = 0.1633576; // 2 May 2016 Julian Emphemeris Date (Teph) =  2457510.5
PSphere [] PS = new PSphere[9]; //generation the planet shape
float [] pltsY = new float [9]; // position of planets in X
float [] pltsX = new float [9]; // position of planets in Y
float [] pltsZ = new float [9]; // position of planets in Z   

// Zoom, rotation, position parameters
int zoomDist;
float Azoom;
int state = 0;
float speed = 0 ;
float zoom =100;
int rS = (int)(pow(zoom, 0.33)*5);
float zoomSc;
float rY = 0;
float rX = 0;
boolean pan;
boolean debugging;
boolean play = false;
boolean pause;
PVector mid, pushBack, b2, v, user;


//Arrays of colour used for the each planets 
color[] palette = {
  #170202, #DE7128, #8CB9AC, #E5813F, #2321FA, #A08F3C, #C9A512, #1AE87B, #AEDCE5, #5B59E8, #EA7676
};
color[] col = palette;
//generating star in the space 
int Stars = 2000;
int strs[][] = new int[Stars][2];

void setup() {
  size(600, 600, P3D);
  smooth(8);
  noStroke();
  frameRate(40);
  //  camera(500, 1200, 400, width/2, height/2, 0, 0, 1, 0);
  //  cam = new PeasyCam(this, 100);

  zoomSc = 1;
  mid = new PVector(width/2, height/2, 0);
  pushBack = new PVector(0, 0, height/1.25);
  user = new PVector(0, 0, 0);

  for (int i = 0; i < Stars; i++) {
    strs[i][0] = int(random(0, width*5.5));
    strs[i][1] = int(random(0, height*5.5));
  }

  // The radius values used are in km, however the radius of sun, jupiter, satrun uranas and neptune is scaled down
  // for visual propose. 
  // PS(float r, color c, boolean moon, float nom, float mDist, float mR, float morbSpeed, boolean ring)
  PS[0] = new PSphere(0.9*rS, col[1], false, 0, 0, 0, 0, false); //sun  25
  PS[1] = new PSphere(0.105*rS, col[2], false, 0, 0, 0, 0, false); // mercury - 2.44 radius
  PS[2] = new PSphere(0.262*rS, col[3], false, 0, 0, 0, 0, false); // venus - 6.052
  PS[3] = new PSphere(0.274*rS, col[4], true, 1, 12, 0.086*rS, 0.025, false); // earth - 6.371
  PS[4] = new PSphere(0.146*rS, col[5], true, 2, 8, 0.086*rS, 0.03, false); // mars - 3.39
  PS[5] = new PSphere(0.753*rS, col[6], false, 0,0, 0, 0, false); // jupiter - 34.91 (17.45)
  PS[6] = new PSphere(0.667*rS, col[7], false, 0, 0, 0, 0, true); //saturn 15.12
  PS[7] =  new PSphere(0.547*rS, col[8], false, 0, 0, 0, 0, false); // uranas 12.681
  PS[8] =  new PSphere(0.531*rS, col[9], false, 0, 0, 0, 0, false); // neptune 12.31
}

void draw() {
  background(col[0]);

  for (int i = 0; i < Stars; i ++) {
    fill(255);
    rect(strs[i][0]+10, strs[i][1]+10, 1, 1);
  }

  for (int i = 0; i < 8; i++) {
    float position[] = PositionPS(i, time);
    pltsX[i] = (float)position[0];
    pltsZ [i]= (float)position[2];
    pltsY[i] = (float)position[1];
  }
  lights();
  //directionalLight(51, 102, 126, -1, 0, 0);
  for (int i = 0; i < 8; i++) {
    rotateX(rX); 
    rotateY(rY);
    noStroke();
    pushMatrix();
    translate( mid.x + pltsX[i]*zoom, mid.y - zoom*pltsY[i], height/2.5);
    scale(zoomSc);
    PS[i].display();
    popMatrix();
  }
  if (debugging) {
    for (int j = 0; j < 8; j++) {
      pushMatrix();
      translate(0, 0, height/2.5);
      stroke(#3F35E3);
      strokeWeight(1);
      line(height/2, height/2, mid.x + pltsX[j]*zoom, mid.y - zoom*pltsY[j]);
      popMatrix();
    }
  }
  if(play) {
    time += 0.00001;
  } 
  possText();

  if (state == 1) {
    if (zoomDist < 0) {
      speed -= .2;
      if (speed < 0) {
        speed = 0;
        state = 0;
      }
    } else {
      speed += .2;
      if (speed > PI) {
        speed = PI;
        state = 0;
      }
    }
    zoom = 8 + Azoom * pow(1+cos(speed) * 0.2, 2 );
    int rS = (int)(pow(zoom, 0.33)*5);
  }
}
void possText() {

  strokeWeight(1);
  fill(255);
  textSize(15);
  int year = int (time* 100 + 2000);
  text("Earth years =" + year, 5, 10);
  float Av = year-2000;
  float Av1 = Av/100;
  float dTime = time - Av1;
  int eDay = (int) (dTime * 36525);
  if (eDay > 365) { 
    eDay += 0;
  }
  text("No. of Days=" + eDay, 5, 30);
  text("---Key Codes---", 5, 60);
  text("1 to Play, 2 to Pause", 5, 180);
  text("'+ or =' to zoomIn", 5, 80);
  text("'- or _' to zoomOut", 5, 100);
  text("Space to pan", 5, 120);
  text("'/ or ?' to stop_pan", 5, 140);
  text("Click to view different zoom scale", 5, 160);
  
}


//void label() {
//  x3 = screenX(x+2*a*e+radius,y,0); 
//  y3 = screenY(x+2*a*e,y,0);
//  z3 = screenZ(x+2*a*e,y,0);

//*******************************************************************************************************
// Keplerian Element for Approximate Position of the Majar Planets 
// The postion of the positions of the nie major planets may is found by the keplerian formulae,
// the Formulea for using the keplerain elements and their raites with respect to the mean eclipitic
// and equinox of J2000, valid for the time-interval 1800 AD - 2050AD. 
// (link to the pdf publish by NASA)http: ssd.jpl.nasa.gov/txt/aprx_pos_planets.pdf
// this is inpsired by Robby Kraft from github - http://robbykraft.com/
//********************************************************************************************************
//                               a           e           I            L         Lomega         Pomega
//                              AU          rad         deg          deg          deg           deg

float elements[] =         {    0,         0,           0,         0,             0,            0,      // sun
                            0.38709927, 0.20563593, 7.00497902, 252.25032350, 77.45779628, 48.33076593, //mercury
                            0.72333566, 0.00677672, 3.39467605, 181.97909950, 131.60246718, 76.67984255, //venus
                            1.00000261, 0.01671123, -0.00001531, 100.46457166, 102.93768193, 0.0, //earth moon barycenter
                            1.52371034, 0.09339410, 1.84969142, -4.55343205, -23.94362959, 49.55953891, //mars
                            5.20288700, 0.04838624, 1.30439695, 34.39644051, 14.72847983, 100.47390909, //jupiter
                            9.53667594, 0.05386179, 2.48599187, 49.95424423, 92.59887831, 113.66242448, //saturn
                            19.18916464, 0.04725744, 0.77263783, 313.23810451, 170.95427630, 74.01692503, //uranus
                            30.06992276, 0.00859048, 1.77004347, -55.12002969, 44.96476227, 131.78422574,}; //neptune
                            
//                         AU/Cy         rad/Cy       deg/Cy      deg/Cy          deg/Cy      deg/Cy
float rates[] =         {      0,         0,           0,           0,              0,          0,
                         0.00000037,  0.00001906, -0.00594749, 149472.67411175,0.16047689, -0.12534081,  //mercury
                         0.00000390, -0.00004107, -0.00078890, 58517.81538729, 0.00268329, -0.27769418,  //venus
                         0.00000562, -0.00004392, -0.01294668, 35999.37244981, 0.32327364,  0.0,         //earth moon barycenter
                         0.00001847,  0.00007882, -0.00813131, 19140.30268499, 0.44441088, -0.29257343,  //mars
                        -0.00011607, -0.00013253, -0.00183714, 3034.74612775,  0.21252668,  0.20469106,  //jupiter
                        -0.00125060, -0.00050991,  0.00193609, 1222.49362201, -0.41897216, -0.28867794,  //saturn
                        -0.00196176, -0.00004397, -0.00242939, 428.48202785,   0.40805281,  0.04240589,  //uranus
                         0.00026291,  0.00005105,  0.00035372, 218.45945325,  -0.32241464, -0.00508664,};  //neptune
                       



float [] PositionPS(int PPs, float time) {

  // computing  the six keplerian's elements
  float a = elements[6*PPs+0] + rates[6*PPs+0]*time;    //  semi_major_axis
  //println( a = elements[6*PPs+0] + rates[6*PPs+0]*time);
  float e = (elements[6*PPs+1] + rates[6*PPs+1]*time);    //  eccentricity
  float I = elements[6*PPs+2] + rates[6*PPs+2]*time;    //  inclination
  float L = elements[6*PPs+3] + rates[6*PPs+3]*time;    //  mean_longitude
  float Lomega = elements[6*PPs+4] + rates[6*PPs+4]*time;    //  longitude of perihelion
  float Pomega = elements[6*PPs+5] + rates[6*PPs+5]*time;    //  longitude of the ascending node


  // compute the argument of perihelion, omega and the mean anomaly M:
  float  omega = Lomega -  Pomega;
  float M = L - Lomega;

  while (M > 180) M -=360;
  //btain the eccentric anomaly, E, from the solution of Kepler’s equation
  float E = M + (58.29578*e) * sin((float)M*PI/180); //E0
  for (int i = 0; i < 5; i++) {  // iterate for precision, 10^(-6) degrees is sufficient
    E = KeplersEquation(E, M, e);
  }

  //planets holiocentric coordinates in its orbital plane r', with
  //x - axis aligned from the focus to the perihelion.
  omega = omega * PI/180;
  E = E * PI/180;
  I = I * PI/180;
  Pomega = Pomega * PI/180;
  float Xprime = a * (cos((float)E)-e);
  float Yprime = a * sqrt((float)(1-e*e))*sin((float)E);

  // compute the coordinates in the J2000 ecliptic plane, with the x-axis aligned toward the equinox:
  float ePlaneXYZ[] = new float [3];
  ePlaneXYZ[0] = (cos((float)omega)*cos((float)Pomega) - sin((float)omega)*sin((float)Pomega)*cos((float)I) )*Xprime + ( -sin((float)omega)*cos((float)Pomega) - cos((float)omega)*sin((float)Pomega)*cos((float)I) )*Yprime ;
  ePlaneXYZ[1] = (cos((float)omega)*sin((float)Pomega) + sin((float)omega)*cos((float)Pomega)*cos((float)I) )*Xprime + ( -sin((float)omega)*sin((float)Pomega) + cos((float)omega)*cos((float)Pomega)*cos((float)I) )*Yprime ;
  ePlaneXYZ[2] = (sin((float)omega)*sin((float)I))*Xprime + (cos((float)omega)*sin((float)I))*Yprime;
  return ePlaneXYZ;
}

float KeplersEquation(float E, float  M, float  e)
{

  float dM = M - (E - (e * 180/PI )* sin((float)E*PI/180));
  float dE = dM / (1 - e*cos((float)E*PI/180));
  return E + dE;
}

float [] orbitPath(int PPs) {
  float a = elements[6*PPs+0] + rates[6*PPs+0]*time;    
  float e = elements[6*PPs+1] + rates[6*PPs+1]*time; 


  float Ra = a * (1 - e);

  float cwh [] = new float [3];
  cwh[0] = (a - Ra)/2;
  cwh[1] = (a + Ra)/2;
  cwh[2] = cwh[1] * sqrt(1 - e*e);

  return cwh;
}
void mouseWheel(MouseEvent event) {
  float  e = event.getCount(); 
  zoom = zoom* pow(2, e/100);
  if (zoom < 5.5 )zoom = 5.5;
  else if (zoom > 2000) zoom = 2000;
  rS = (int) ((pow(zoom, 0.333)));
}

void mouseClicked() {
  if (state == 0) {
    if (zoom < 6) {
      Azoom = 100-zoom;
      zoomDist = -1;
      speed = PI;
    } else {
      Azoom = zoom-10;
      zoomDist = 1;
      speed = 0;
    }
    state = 1;
  }
}

void mouseMoved() {
  if (pan) {
    rY = -(mouseY - height / 2) * PI / ( height/2); 
    rX = (mouseX - width /2) * PI / (height/2);
  } else { 
    pan = false;
  }
}

void keyPressed() {
  if (key == '1' || key == '!') play = true;
  if (key == '2' || key == '@') play = false;
  if (key == '+' || key == '=') zoomSc += .1; 
  if (key == '-' || key == '_') zoomSc -= .1;
  if (key == '`' || key == '~')              debugging = !debugging;
  if (key == ' ')              pan = true;
  if (key == '/') pan = false;
  if (key == '0' || key == ')')   user.sub(cos( rY)*2, 0, sin(rY)*2);
}


class Moon {
  float theta;
  float mRadius;
  float mDist;
  float orbSpeed;

  Moon(float mDist_, float mRadius_, float orbSpeed_) {
    mDist = mDist_;
    mRadius = mRadius_;
    theta = 0;
    orbSpeed = orbSpeed_;
  }

  void update() {
    theta += orbSpeed; // simple way for assigning the moon to orbits
  }

  void display() {
    update();
    pushMatrix();
    rotate(theta);
    translate(mDist, 0);
    noStroke();
    lights();
    fill(#C1BFC1);
    sphere(mRadius);
    popMatrix();
  }
}


 

 
 class PSphere { 
     float x, y, z, vel;
  boolean moon;
  boolean ring;
  float nom, mDist, morbSpeed, mR;
  float r;
  color c;
  float theta;
  int b;
 Moon [] m = new Moon[5];
  PSphere(float r, color c, boolean moon, float nom, float mDist, float mR, float morbSpeed, boolean ring) {
    //  PSphere(float r, color c) {
    this.r = r;
    this.c = c;
    this. moon = moon;
    this.nom = nom;
    this.mDist = mDist;
    this.mR = mR;
    this.morbSpeed = morbSpeed;
    this.ring = ring;
    if (moon) {
      for (int i = 0; i < nom; i++) {
        m[i] = new Moon( mDist, mR, morbSpeed);
      }
    }
    theta = 0;
  }

  void update() {
    theta += morbSpeed;
    if (moon) {
      for (int i = 0; i < nom; i++) {
        m[i].update();
      }
    }
  }
  void display() {
    update();
    fill(c);
    //    lights();
    //    pointLight(255, 255, 0, 0, 0);
    sphere(r);
    //translate(r, 0, 0);
    if (moon) {
      rotateY(theta);
      for (int i =0; i < nom; i++) {
        pushMatrix();
        rotate(radians(i+90));
        m[i].display();
        popMatrix();
      }
    }

    if (ring) {
      noFill();
      stroke(#24F0BE);
      rotateY(radians(-30));
      ellipse(0, 0, r*3, r*3);
      ellipse(0, 0, r*3.2, r*3.2);
      ellipse(0, 0, r*3.4, r*3.4);
      ellipse(0, 0, r*3.6, r*3.6);
    }
  }
}

