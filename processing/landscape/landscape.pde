/* ----------------------------------------------------------------------------------------------------
 * Google Position History to GRAPHIC, 2017
 * Update: 12/07/17
 *
 * TODO : Check Month & Draw Lines
 *
 * V0.5
 * Written by Bastien DIDIER
 * ----------------------------------------------------------------------------------------------------
 */
import processing.pdf.*;

//------- JSON DATA ---------
JSONArray GooglePositionHistory;
String position_history_file = "Gautier_Raguenaud_2016_decembre.json";

String     timestampMs = "1489432985771";
String lastTimestampMs = "1489432985771";

boolean firstTime = true;
boolean ShapeIsBegin = false;
boolean ShapeIsFinish = false;

//------- CONFIG LANDSCAPE ---------
float y;
int margin = 30;
int landscape_count = 0;
int month_count = 0;
int amplitude = 12 ; //1 > 100

//------- LANDSCAPE DATA -----------
float x_landscape = margin;
float last_x_landscape = margin;
float y_landscape = 0;
float last_y_landscape = 0;

void setup ()
{
  size (400, 400);
  //size(400, 400, PDF, "export.pdf");
  smooth();
  
  background(197,230,255);
  Position_to_landscape();
  
  //exit();
}

void Position_to_landscape() {
  GooglePositionHistory = loadJSONArray(position_history_file);

  for (int i = GooglePositionHistory.size()-1; i > 0; i--) {

    //------- GET JSON DATA ---------
    JSONObject locations = GooglePositionHistory.getJSONObject(i);

    int accuracy = locations.getInt("accuracy");
    int latitude = locations.getInt("latitudeE7");
    int longitude = locations.getInt("longitudeE7");

    timestampMs = locations.getString("timestampMs");
    //timestampMs = str(locations.getInt("timestampMs"));
    
    //println(month);
    
    //------- PROCESS JSON DATA ---------
    if(firstTime == true){
      y = accuracy/amplitude;
      firstTime = false;
    } 
    
    if(y < height-margin){  
      
      //------- CHECK MONTH DATA -----------
      if(month == lastMonth && landscape_count < 12){
        
        float r = random(0, 200);
        float v = random(150, 255);
        float b = random(50, 200);
          
        //------- GENERATE LANDSCAPE FROM JSON DATA ---------
        if(ShapeIsBegin != true){
          fill (r,v,b);
          noStroke();
    
          //println("Begin Shape");
          beginShape ();
          vertex (margin, height-margin);
          vertex (x_landscape, y_landscape);
          ShapeIsBegin = true;
            
        } else if(ShapeIsBegin == true && ShapeIsFinish == true){
            
          //println("End Shape");
          vertex (width-margin, y_landscape);
          vertex (width-margin, height-margin);
          endShape(CLOSE);
            
          ShapeIsBegin = false;
          ShapeIsFinish = false;
          landscape_count++;
          
        } else {
          //println("Create Vertex");
            
          y_landscape = map(longitude/100000, 100,240, 100, 300); //y - longitude/100000
            
          if(y_landscape != last_y_landscape && y_landscape > margin){
            vertex (x_landscape, y_landscape);
            last_y_landscape = y_landscape;
            last_x_landscape = x_landscape;
            
            //TODO DRAW LINE
            /*noFill ();
            strokeWeight(1);
            stroke(0);
            line (x_landscape, y_landscape, x_landscape, y_landscape+50);
            
            int data = 10; //accuracy
            for (int j = 0; j <= data; j++) {
              line(
                lerp(last_x_landscape, x_landscape, j)+100,
                lerp(last_y_landscape, y_landscape, j),
                x_landscape,
                y_landscape+50
              );
            }
            
            //fill (r,v,b);
            noStroke();*/
            
            x_landscape += map(processTimestamp(timestampMs, lastTimestampMs)/1000, 0,10, 10, 20); //15/25
          }
          
          if(x_landscape > width-margin){
            ShapeIsFinish = true;
            x_landscape = margin;
          }
        }
        //lastMonth = month;
      } else {
        y += accuracy/amplitude;
        lastMonth = month;
        month_count++;
      }
    }
    //lastTimestampMs = timestampMs;
  }
  println("Month Count : "+month_count);
  println("FINISH !");
  drawMargin();
}