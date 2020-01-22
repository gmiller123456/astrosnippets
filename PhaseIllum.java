
import static java.lang.Math.*;
/**
 * Created by Greg Miller on 4/30/2015.
 */
public class PhaseIllum {

    public static void main(String args[]){
        for(int i=0;i<10;i++){
            double d=PhaseAngle(2451665.5+i);
            double illum=Illuminated(d);
            System.out.printf("%6.2f %6.2f\n",toDegrees(d),illum);
        }
        System.out.println("Here");
    }

    public static double Illuminated(double i) {
        // (41.1) p. 283, also (48.1) p. 345.
        return (1 + cos(i)) * .5;
    }

    public static double PhaseAngle(double jde) {
        double T = J2000Century(jde);
        double p = PI / 180;
        double D = Horner(T, 297.8501921*p, 445267.1114034*p,-.0018819*p, p/545868, -p/113065000);
        double M = Horner(T, 357.5291092*p, 35999.0502909*p,-.0001535*p, p/24490000);
        double Mp = Horner(T, 134.9633964*p, 477198.8675055*p,.0087414*p, p/69699, -p/14712000);
        return PI - PMod(D, 2*PI) +
                -6.289*p*sin(Mp) +
                2.1*p*sin(M) +
                -1.274*p*sin(2*D-Mp) +
                -.658*p*sin(2*D) +
                -.214*p*sin(2*Mp) +
                -.11*p*sin(D);
    }

    public static double J2000Century(double jde){
        return (jde-2451545.0)/36525.0;
    }

    public static double PMod(double x, double y)  {
        double r = x%y;
        if (r < 0) {
            r += y;
        }
        return r;
    }

    public static double Horner(double x, double... c) {
        int i = c.length - 1;
        double y = c[i];
        while (i > 0) {
            i--;
            y = y*x + c[i]; // sorry, no fused multiply-add in Go
        }
        return y;
    }

}
