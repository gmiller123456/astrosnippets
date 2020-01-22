/*
IAU resolution 3 of 2006[7] defines TDB as a linear transformation of TCB. TCB diverges from both TDB and TT. TCB progresses faster at a differential rate of about 0.5 second/year, while TDB and TT remain close.[8] As of the beginning of 2011, the difference between TDB and TCB is about 16.6 seconds.

TDB = TCB − LB×(JDTCB − T0)×86400 + TDB0
where LB = 1.550519768×10−8, TDB0 = −6.55×10−5 s, T0 = 2443144.5003725, and JDTCB is the TCB Julian date (that is, a quantity which was equal to T0 on 1977 January 1 00:00:00 TAI at the geocenter and which increases by one every 86400 seconds of TCB).
*/

public class TDB {
	public static void main(String[] args){
		System.out.println("here");
	}

	public double TCB2TDB(double TCB){
		double LB = 1.550519768*10-8;
		double TDB0 = -6.55*10-5;
		double T0 = 2443144.5003725;
		//double JDTCB is the TCB Julian date (that is, a quantity which was equal to T0 on 1977 January 1 00:00:00 TAI at the geocenter and which increases by one every 86400 seconds of TCB).
		double TDB = TCB - LB*(JDTCB - T0)*86400 + TDB0;

	}
}