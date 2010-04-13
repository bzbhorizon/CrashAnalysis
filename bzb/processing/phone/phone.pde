import processing.opengl.*;
import jmcvideo.*;
/*import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;*/

final String path = "E:/eclipsews/CrashAnalysis/res/";

String[] lines;
int frame, offsetY, offsetX, offsetZ, catchup;
float lastX, lastY, lastZ, lastTime;
JMCMovie myMovie;

/*RollingLine2DTrace r,r2,r3;
Graph2D g;

class eqX implements ILine2DEquation{
	public double computePoint(double x,int pos) {
		return offsetX;
	}		
}

class eqY implements ILine2DEquation{
	public double computePoint(double x,int pos) {
		return offsetY;
	}		
}

class eqZ implements ILine2DEquation{
	public double computePoint(double x,int pos) {
		return offsetZ;
	}		
}*/

void setup() {  
  size(screen.width, screen.height, OPENGL);
  catchup = 0;
  lines = loadStrings(path + "slog.csv");
  frame = 0;
  String[] bits = split(lines[6], ',');
  lastX = float(bits[2]);
  lastY = float(bits[3]) + 180;
  lastZ = float(bits[4]) + 180;
  lastTime = float(bits[0].substring(5));
  myMovie = new JMCMovie(this, new File(path + "vlog.3gp"), RGB);
  myMovie.play();
  
  /*
        r = new RollingLine2DTrace(new eqX(),500,0.5);
	r.setTraceColour(0, 255, 0);
	
	r2 = new RollingLine2DTrace(new eqY(),500,0.5);
	r2.setTraceColour(255, 0, 0);
	
	r3 = new RollingLine2DTrace(new eqZ(),500,0.5);
	r3.setTraceColour(0, 0, 255);
	 
	g = new Graph2D(this, 400, 200, false);
        
        g.setYAxisMin(-20);
	g.setYAxisMax(20);
        g.setYAxisLabel("Acceleration");
        g.setXAxisLabel("Seconds elapsed");
	g.position.y = 500;
	g.position.x = 500;
	g.setYAxisTickSpacing(5);
	g.setXAxisMax(5f);

	g.addTrace(r);
	g.addTrace(r2);
	g.addTrace(r3);*/
}
int pvw, pvh;
void draw() {
  float started = millis();
  
  //image(myMovie, screen.width/2, 0);
    
  String[] bits = split(lines[frame], ',');

  if (int(bits[1]) == 1) {
    offsetY = int(float(bits[4])/30 * screen.height/2);
    offsetX = int(float(bits[2])/30 * screen.width/2);
    offsetZ = int(float(bits[3])/20);
//    g.draw();
  }

  if (int(bits[1]) == 3) {
    translate(screen.height/4 - offsetX ,screen.height/4 - offsetY, offsetZ); 
    background(255);
    float thisX = float(bits[2]);
    float thisY = float(bits[3]) + 180;
    float thisZ = float(bits[4]) + 180;
    rotateY(radians(thisX - 180));
    rotateX(radians(thisY));
    rotateZ(radians(thisZ));
    lastX = thisX;
    lastY = thisY;
    lastZ = thisZ;
    
    fill(255);
    box(100, 50, 200);
    
    translate(0, -20, 20);
    box(90, 10, 150);

    translate(0, 20, -20);
    rotateY(radians(180));
    textAlign(CENTER);
    textFont(createFont("Arial", 12));
    fill(0);
    rotateX(radians(90));
    text("front", 0, 0, 40);
    text("back", 0, 0, -40);
    /*rotateX(radians(-90));
    rotateY(radians(90));
    text("right", 0, 70, 0);
    text("left", -70, 0, 0);*/
  
    float thisTime = float(bits[0].substring(5));
    float delay = thisTime - lastTime - (millis() - started) + catchup;

    if (delay > 5000) {
      delay = 5000;
    } else if (delay < 0) {
      catchup = int(delay);
      delay = 0;
    }
    //println(delay);
    delay(int(delay*0.65));
    lastTime = thisTime;
  } else {
    catchup -= int(millis() - started);
  }
  
  if (frame < lines.length - 1) {
    frame++;
  } else {
    /*background(255);
    delay(1000);
    frame = 0;*/
    println(millis() / 1000);
    exit();
  }
  
  
  
  
}


