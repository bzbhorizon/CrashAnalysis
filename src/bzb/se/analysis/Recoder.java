package bzb.se.analysis;

/**
 * 
 */
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;

/**
 * @author bzb
 *
 */
public class Recoder {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		String filename = "res/glog.csv";
		
		String kml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
			"<kml xmlns=\"http://www.opengis.net/kml/2.2\"><Document><Placemark><LineString>"+
        "<extrude>1</extrude>"+
        "<tessellate>1</tessellate>"+
        "<altitudeMode>absolute</altitudeMode>"+
        "<coordinates>";
		
		FileInputStream fin;
		try	{
		    fin = new FileInputStream (filename);
		    DataInputStream dis = new DataInputStream(fin);
		    while (dis.available() != 0) {
		    	String[] bits = dis.readLine().split(",");
		    	if (bits.length > 2) {
		    		kml +=  bits[2] + "," + bits[1] + "," + bits[4] + ",";
		    	}
		    }
		    fin.close();		
		} catch (IOException e)	{
			System.err.println ("Unable to read from file");
			System.exit(-1);
		}
		      
		kml += "</coordinates></LineString></Placemark></Document></kml>";
		
		FileOutputStream fout;
		try {
		    fout = new FileOutputStream (filename + ".kml");
		    new PrintStream(fout).print(kml);
		    fout.close();		
		} catch (IOException e)	{
			System.err.println ("Unable to write to file");
			System.exit(-1);
		}


	}

}
