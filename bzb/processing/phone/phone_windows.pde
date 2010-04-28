import guicomponents.*;
import processing.opengl.*;
import jmcvideo.*;
import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;

private GWindow[] window;

final String path = "C:/Users/bzb/workspace/CrashAnalysis/res/";

String[] lines;
int frame, offsetY, offsetX, offsetZ, catchup;
float lastX, lastY, lastZ, lastTime, started;
JMCMovie myMovie;

RollingLine2DTrace r,r2,r3;
Graph2D g;

class eqX implements ILine2DEquation{
public double computePoint(double x,int pos) {
return offsetX;
}
}

class eqY implements ILine2DEquation{
public double computePoint(double x,int pos) {
    println(offsetY);
return offsetY;
}
}

class eqZ implements ILine2DEquation{
public double computePoint(double x,int pos) {
return offsetZ;
}
}

void setup(){
  size(320,240,P2D);
  myMovie = new JMCMovie(this, new File(path + "vlog.mov"), RGB);
  myMovie.play();
  
  createWindows();
  
  catchup = 0;
  lines = loadStrings(path + "slog.csv");
  frame = 0;
  String[] bits = split(lines[6], ',');
  lastX = float(bits[2]);
  lastY = float(bits[3]) + 180;
  lastZ = float(bits[4]) + 180;
  lastTime = float(bits[0].substring(5));

  started = millis();
  
   r = new RollingLine2DTrace(new eqX(),100,0.1);
r.setTraceColour(0, 255, 0);
r2 = new RollingLine2DTrace(new eqY(),100,0.1);
r2.setTraceColour(255, 0, 0);
r3 = new RollingLine2DTrace(new eqZ(),100,0.1);
r3.setTraceColour(0, 0, 255);
g = new Graph2D(window[1].papplet, 400, 200, false);
g.setYAxisMin(-150);
g.setYAxisMax(150);
g.setYAxisLabel("Acceleration");
g.setXAxisLabel("Seconds elapsed");
g.position.y = 100;
g.position.x = 100;
g.setYAxisTickSpacing(20);
g.setXAxisMax(5f);

g.addTrace(r);
g.addTrace(r2);
g.addTrace(r3);
}

public void createWindows(){
  window = new GWindow[2];
  
  window[0] = new GWindow(this, "Sim window", 130, 100,600,800,false, OPENGL);
  window[0].addData(new MyWinData(0));
  window[0].setBackground(255);
  window[0].addDrawHandler(this, "simDraw");
  
  window[1] = new GWindow(this, "Forces window", 130+420, 100+200,600,400,false,JAVA2D);
  window[1].addData(new MyWinData(1));
  window[1].setBackground(255);
  window[1].addDrawHandler(this, "forcesDraw");
}

/**
 * Draw for the main window
 */
void draw(){
  background(192);
  image(myMovie, 0, 0);
}

/**
 * Handles drawing to the windows PApplet area
 * 
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 */
public void simDraw(GWinApplet appc, GWinData data){
  //appc.background(255);
float delayed = millis() - started;
  started = millis();
  
  //image(myMovie, screen.width/2, 0);
    
  String[] bits = split(lines[frame], ',');

  if (int(bits[1]) == 1) {
    offsetY = int(float(bits[4])/30 * screen.height/2);
    offsetX = int(float(bits[2])/30 * screen.width/2);
    offsetZ = int(float(bits[3])/20);
  }

  if (int(bits[1]) == 3) {
    appc.translate(screen.height/4 - offsetX ,screen.height/4 - offsetY, offsetZ);
    //appc.background(255);
    float thisX = float(bits[2]);
    float thisY = float(bits[3]) + 180;
    float thisZ = float(bits[4]) + 180;
    appc.rotateY(radians(thisX - 180));
    appc.rotateX(radians(thisY));
    appc.rotateZ(radians(thisZ));
    lastX = thisX;
    lastY = thisY;
    lastZ = thisZ;
    
    appc.fill(255);
    appc.box(100, 50, 200);
    
    appc.translate(0, -20, 20);
    appc.box(90, 10, 150);

    appc.translate(0, 20, -20);
    appc.rotateY(radians(180));
    appc.textAlign(CENTER);
    appc.textFont(createFont("Arial", 12));
    appc.fill(0);
    appc.rotateX(radians(90));
    appc.text("front", 0, 0, 40);
    appc.text("back", 0, 0, -40);
    /*rotateX(radians(-90));
rotateY(radians(90));
text("right", 0, 70, 0);
text("left", -70, 0, 0);*/
  
    float thisTime = float(bits[0].substring(5));
    float delay = thisTime - lastTime - delayed + catchup;

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
    catchup -= int(delayed);
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

public void forcesDraw(GWinApplet appc, GWinData data){
   if (g != null) {
    try{
    g.draw();
    }catch(Exception e) {}
  }
}

/**
 * Simple class that extends GWinData and holds the data that is specific
 * to a particular window.
 * 
 * @author Peter Lager
 *
 */
class MyWinData extends GWinData {
  public int id;
  
  public MyWinData (int id) {
    this.id = id;
  }
}
