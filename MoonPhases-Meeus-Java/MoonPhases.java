
/**
 * Created by Greg on 2/19/2018.
 */

/**
 * Call First, Full, Last, New to get the phase closest to the date passed in.
 * Dates (years) are in the format YYYY.fraction so 1999.0 is Jan 1 1999, and 2015.25 is the end of March 2015
 * This library only works to find the moments of First, Full, Last, New phases, everything in between is nonsense.
 */
 import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.TimeZone;
import java.util.Date;

 
public class MoonPhases {
	public static void main(String[] args) {
		double year=2018.0;
		while(year<2018.1){
			System.out.println(julianToDate(Full(2018.08)).getTime().toString());
			year+=.001;
		}
    }
    public static Calendar julianToDate(double jd) {

        double z, f, a, b, c, d, e, m, aux;
        Date date = new Date();
        jd += 0.5;
        z = Math.floor(jd);
        f = jd - z;

        if (z >= 2299161.0) {
            a = Math.floor((z - 1867216.25) / 36524.25);
            a = z + 1 + a - Math.floor(a / 4);
        } else {
            a = z;
        }

        b = a + 1524;
        c = Math.floor((b - 122.1) / 365.25);
        d = Math.floor(365.25 * c);
        e = Math.floor((b - d) / 30.6001);
        aux = b - d - Math.floor(30.6001 * e) + f;

        Calendar calendar = new GregorianCalendar();
        calendar.setTimeZone(TimeZone.getTimeZone("GMT"));
        calendar.setTime(date);
        calendar.set(Calendar.DAY_OF_MONTH, (int) aux);
        aux = ((aux - calendar.get(Calendar.DAY_OF_MONTH)) * 24);
        calendar.set(Calendar.HOUR_OF_DAY, (int) aux);
        calendar.set(Calendar.MINUTE, (int) ((aux - calendar.get(Calendar.HOUR_OF_DAY)) * 60));

        if (e < 13.5) {
            m = e - 1;
        } else {
            m = e - 13;
        }
        // Se le resta uno al mes por el manejo de JAVA, donde los meses empiezan en 0.
        calendar.set(Calendar.MONTH, (int) m - 1);
        if (m > 2.5) {
            calendar.set(Calendar.YEAR, (int) (c - 4716));
        } else {
            calendar.set(Calendar.YEAR, (int) (c - 4715));
        }
        return calendar;
    }

    // Copyright 2013 Sonia Keys
// License MIT: http://www.opensource.org/licenses/MIT

// Moonphase: Chapter 49, Phases of the Moon

    static double ck = 1 / 1236.85;

    // (49.1) p. 349
    public static double mean(double T){
        return Base.Horner(T, 2451550.09766, 29.530588861/ck,
                .00015437, -.00000015, .00000000073);
    }

    // snap returns k at specified quarter q nearest year y.
    public static double snap(double y, double q ) {
        double k = (y - 2000) * 12.3685; // (49.2) p. 350
        return Math.floor(k-q+.5) + q;
    }

    // MeanNew returns the jde of the mean New Moon nearest the given date.
//
// Year is a decimal year specifying a date.
//
// The mean date is within .5 day of the true date of New Moon.
    public static double MeanNew(double year) {
        return mean(snap(year, 0) * ck);
    }

    // MeanFirst returns the jde of the mean First Quarter Moon nearest the given date.
//
// Year is a decimal year specifying a date.
//
// The mean date is within .5 day of the true date of First Quarter Moon.
    public static double MeanFirst(double year) {
        return mean(snap(year, .25) * ck);
    }

    // MeanFull returns the jde of the mean Full Moon nearest the given date.
//
// Year is a decimal year specifying a date.
//
// The mean date is within .5 day of the true date of New Moon.
    public static double MeanFull(double year) {
        return mean(snap(year, .5) * ck);
    }

    // MeanLast returns the jde of the mean Last Quarter Moon nearest the given date.
//
// Year is a decimal year specifying a date.
//
// The mean date is within .5 day of the true date of Last Quarter Moon.
    public static double MeanLast(double year )  {
        return mean(snap(year, .75) * ck);
    }

    // New returns the jde of New Moon nearest the given date.
//
// Year is a decimal year specifying a date.
    public static double New(double year) {
        mp m = new mp(year, 0);
        return mean(m.T) + m.nfc(nc) + m.a();
    }

    // First returns the jde of First Quarter Moon nearest the given date.
//
// Year is a decimal year specifying a date.
    public static double First(double year) {
        mp m = new mp(year, .25);
        return mean(m.T) + m.flc() + m.w() + m.a();
    }

    // Full returns the jde of Full Moon nearest the given date.
//
// Year is a decimal year specifying a date.
    public static double Full(double year) {
        mp m = new mp(year, .5);
        return mean(m.T) + m.nfc(fc) + m.a();
    }

    // Last returns the jde of Last Quarter Moon nearest the given date.
//
// Year is a decimal year specifying a date.
    public static double Last(double year) {
        mp m = new mp(year, .75);
        return mean(m.T) + m.flc() - m.w() + m.a();
    }

    // new coefficients
    static double[] nc = {
            -.4072,
            .17241,
            .01608,
            .01039,
            .00739,
            -.00514,
            .00208,
            -.00111,
            -.00057,
            .00056,
            -.00042,
            .00042,
            .00038,
            -.00024,
            -.00017,
            -.00007,
            .00004,
            .00004,
            .00003,
            .00003,
            -.00003,
            .00003,
            -.00002,
            -.00002,
            .00002,
    };

    // full coefficients
    static double[] fc = {
            -.40614,
            .17302,
            .01614,
            .01043,
            .00734,
            -.00515,
            .00209,
            -.00111,
            -.00057,
            .00056,
            -.00042,
            .00042,
            .00038,
            -.00024,
            -.00017,
            -.00007,
            .00004,
            .00004,
            .00003,
            .00003,
            -.00003,
            .00003,
            -.00002,
            -.00002,
            .00002,
    };
}
class mp {
    public double k, T;
    public double E, M, Mp, F, omega;
    public double[] A=new double[14];
    static double p = Math.PI / 180;
    static double ck = 1 / 1236.85;


    mp(double y, double q) {
        k=MoonPhases.snap(y, q);
        T = k * ck; // (49.3) p. 350
        E = Base.Horner(T, 1, -.002516, -.0000074);
        M = Base.Horner(T, 2.5534 * p, 29.1053567 * p / ck,
                -.0000014 * p, -.00000011 * p);
        Mp = Base.Horner(T, 201.5643 * p, 385.81693528 * p / ck,
                .0107582 * p, .00001238 * p, -.000000058 * p);
        F = Base.Horner(T, 160.7108 * p, 390.67050284 * p / ck,
                -.0016118 * p, -.00000227 * p, .000000011 * p);
        omega = Base.Horner(T, 124.7746 * p, -1.56375588 * p / ck,
                .0020672 * p, .00000215 * p);
        A[0] = 299.7 * p + .107408 * p * k - .009173 * T * T;
        A[1] = 251.88 * p + .016321 * p * k;
        A[2] = 251.83 * p + 26.651886 * p * k;
        A[3] = 349.42 * p + 36.412478 * p * k;
        A[4] = 84.66 * p + 18.206239 * p * k;
        A[5] = 141.74 * p + 53.303771 * p * k;
        A[6] = 207.17 * p + 2.453732 * p * k;
        A[7] = 154.84 * p + 7.30686 * p * k;
        A[8] = 34.52 * p + 27.261239 * p * k;
        A[9] = 207.19 * p + .121824 * p * k;
        A[10] = 291.34 * p + 1.844379 * p * k;
        A[11] = 161.72 * p + 24.198154 * p * k;
        A[12] = 239.56 * p + 25.513099 * p * k;
        A[13] = 331.55 * p + 3.592518 * p * k;
    }

    // new or full corrections
    public double nfc (double[] c) {
        return c[0] * Math.sin(Mp) +
                c[1] * Math.sin(M) * E +
                c[2] * Math.sin(2 * Mp) +
                c[3] * Math.sin(2 * F) +
                c[4] * Math.sin(Mp - M) * E +
                c[5] * Math.sin(Mp + M) * E +
                c[6] * Math.sin(2 * M) * E * E +
                c[7] * Math.sin(Mp - 2 * F) +
                c[8] * Math.sin(Mp + 2 * F) +
                c[9] * Math.sin(2 * Mp + M) * E +
                c[10] * Math.sin(3 * Mp) +
                c[11] * Math.sin(M + 2 * F) * E +
                c[12] * Math.sin(M - 2 * F) * E +
                c[13] * Math.sin(2 * Mp - M) * E +
                c[14] * Math.sin(omega) +
                c[15] * Math.sin(Mp + 2 * M) +
                c[16] * Math.sin(2 * (Mp - F)) +
                c[17] * Math.sin(3 * M) +
                c[18] * Math.sin(Mp + M - 2 * F) +
                c[19] * Math.sin(2 * (Mp + F)) +
                c[20] * Math.sin(Mp + M + 2 * F) +
                c[21] * Math.sin(Mp - M + 2 * F) +
                c[22] * Math.sin(Mp - M - 2 * F) +
                c[23] * Math.sin(3 * Mp + M) +
                c[24] * Math.sin(4 * Mp);
    }


    // first or last corrections
    double flc() {
        return -.62801 * Math.sin(Mp) +
                .17172 * Math.sin(M) * E +
                -.01183 * Math.sin(Mp + M) * E +
                .00862 * Math.sin(2 * Mp) +
                .00804 * Math.sin(2 * F) +
                .00454 * Math.sin(Mp - M) * E +
                .00204 * Math.sin(2 * M) * E * E +
                -.0018 * Math.sin(Mp - 2 * F) +
                -.0007 * Math.sin(Mp + 2 * F) +
                -.0004 * Math.sin(3 * Mp) +
                -.00034 * Math.sin(2 * Mp - M) +
                .00032 * Math.sin(M + 2 * F) * E +
                .00032 * Math.sin(M - 2 * F) * E +
                -.00028 * Math.sin(Mp + 2 * M) * E * E +
                .00027 * Math.sin(2 * Mp + M) * E +
                -.00017 * Math.sin(omega) +
                -.00005 * Math.sin(Mp - M - 2 * F) +
                .00004 * Math.sin(2 * Mp + 2 * F) +
                -.00004 * Math.sin(Mp + M + 2 * F) +
                .00004 * Math.sin(Mp - 2 * M) +
                .00003 * Math.sin(Mp + M - 2 * F) +
                .00003 * Math.sin(3 * M) +
                .00002 * Math.sin(2 * Mp - 2 * F) +
                .00002 * Math.sin(Mp - M + 2 * F) +
                -.00002 * Math.sin(3 * Mp + M);
    }

    double w() {
        return .00306 - .00038 * E * Math.cos(M) + .00026 * Math.cos(Mp) -
                .00002 * (Math.cos(Mp - M) - Math.cos(Mp + M) - Math.cos(2 * F));
    }

    // additional corrections
    double a(){
        double a=0;
        for(int i=0;i<ac.length;i++){
            a += ac[i] * Math.sin(A[i]);
        }
        return a;
    }

    double[] ac = {
            .000325,
            .000165,
            .000164,
            .000126,
            .00011,
            .000062,
            .00006,
            .000056,
            .000047,
            .000042,
            .000040,
            .000037,
            .000035,
            .000023,
    };
}

class Base {
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

    public static double Illuminated(double i) {
        // (41.1) p. 283, also (48.1) p. 345.
        return (1 + Math.cos(i)) * .5;
    }
}
