/*
* Created by Biran4454
* https://github.com/biran4454/3D-Orrery-no-physics
* 2019 - 2020
*/
/*
Notes:
  Controls:
    Left-click: rotate
    Right-click / mouse wheel: zoom
    Middle-click: pan
    0: focus on Sun
    3: focus on Earth
    4: focus on Moon
    5: focus on Mars
  TODO: Add a way to make planets and planet trails eccentric in z axis.
        Make trails relative to the centre of the screen, (focused object).
        Add notes to the code and add some more tabs and clean everything up - it will save time in the long run.
        Add a way to go backwards in time.
        Offset the planet's start position.
*/
/*
HOW TO GET INCREMENTS OF TIME SPEED (Just me working out some maths):
	1. Get start speed - actual speed
	2. actual speed = start speed * 2^(number of multiplications)
	3. actual speed / start speed = 2^(number of multiplications)
	4. log(actual speed / start speed) = number of multiplications * log(2)
	5. log(actual speed / start speed) / log(2) = number of multiplications
*/
import peasy.*; //REQUIRES PEASYCAM LIBRARY. USE MENU "Sketch>Import Library>Add library>PeasyCam>Install" TO ADD.

//////////////////////////////////////////////////////  VARIABLES  /////////////////////////////////////////////////////////////////

///////////////////////////////////////////  USER-SET VARIABLES  ////////////////////////////////////////////////

float planetSizeScale = 10; // 1 = life size compared to sun.
float moonSizeScale = 10;
float planetDistanceScale = 1; // 1 = life size compared to sun etc.
float moonDistanceScale = 7;
float gasSizeScale = 0.8; // Scale of gas giants compared to terrestrial planets. 1 = life size.

float timeSpeed = 0.01; // Starting time scale, but changeable with 'q' and 'e' in-sim.
boolean orbitTrails = true; // Enable planet + moon orbital trails. Can be changed in-sim with 'o'.
boolean showLables = true; // Enable planet + moon lables. Can be changed in-sim with 'l'.
color planetTrailColour = color(0, 255, 0); // Colour of planet trails.
color moonTrailColour = color(255, 0, 0); // Colour of moon trails.
boolean paused = false; // Is the program paused? Set here to make the program start paused. Can be changed in-sim with [SPACE].
boolean loadTextures = false; // Load the object textures on startup? If true, it will take longer, but will look nicer.

/////////////////////////////////////////////////  STANDARD VARIABLES  /////////////////////////////////////////////////////

String version = "11.1";

float t = 0;
int planetFocus, pPlanetFocus = 0;
float xFocus = 0;
float yFocus = 0;
float zFocus = 0;
boolean pKeyPressed = false;
String focusName = "-";
float startTimeSpeed = timeSpeed;
int timeSpeedIncrements = 0;
PShape sun;
ArrayList<String> notifications;
ArrayList<Integer> notificationTimes;
boolean wasFPSLow;

////////////////////////////////////////////////////////  CLASSES  //////////////////////////////////////////////////////////////////

// Insert classes here to have only one file / tab.

////////////////////////////////////////////////////////  FUNCTIONS  /////////////////////////////////////////////////////////////////

void checkKeys(){
  if(!pKeyPressed){
    if(keyPressed){
      pKeyPressed = true;
      switch(key){
        case '0': planetFocus = 0; break;
        case '1': planetFocus = 1; break;
        case '2': planetFocus = 2; break;
        case '3': planetFocus = 3; break;
        case '4': planetFocus = 4; break;
        case '5': planetFocus = 5; break;
        case '6': planetFocus = 6; break;
        
        case 'q': if(timeSpeed > 0.0005){
                    timeSpeed /= 2;
                    addNotification("Time speed decreased", 150);
                  }
                  else{
                    println("Min speed reached. Use SPACE to pause / unpause");
                    addNotification("Minimum speed reached", 150);
                  }
                  timeSpeedIncrements = int(log(timeSpeed / startTimeSpeed) / log(2)); // Number of multiplies
                  
                  break;
        case 'e': if(timeSpeed < 1){
                    timeSpeed *= 2;
                    addNotification("Time speed increased", 150);
                  }
                  else{
                    println("Max speed reached.");
                    addNotification("Maximum speed reached", 150);
                  }
                  timeSpeedIncrements = int(log(timeSpeed / startTimeSpeed) / log(2));
                  break;
        
        case 'l': showLables = !showLables; addNotification("Lables shown: " + showLables, 150); break;
        case 'o': orbitTrails = !orbitTrails; addNotification("Orbit trails shown: " + orbitTrails, 150); break;
        case ' ': paused = !paused; break;
      }
    }
  }
  else{
    if(!keyPressed){
      pKeyPressed = false;
    }
  }
  if(keyPressed){
    switch(keyCode){
        case 38: cam2.setDistance(cam2.getDistance() + cam2.getDistance() / 2); break;
        case 40: cam2.setDistance(cam2.getDistance() - cam2.getDistance() / 2); break;
    } 
  }
}
void focusPlanet(){
 switch(planetFocus){
   case 0: xFocus = 0; yFocus = 0; zFocus = 0;
     focusName = "Sun";
     break;
   case 1: xFocus = mercury.getPosition(t)[0]; yFocus = mercury.getPosition(t)[1]; zFocus = 0;
     focusName = "Mercury";
     break;
   case 2: xFocus = venus.getPosition(t)[0]; yFocus = venus.getPosition(t)[1]; zFocus = 0;
     focusName = "Venus";
     break;
   case 3: xFocus = earth.getPosition(t)[0]; yFocus = earth.getPosition(t)[1]; zFocus = 0;
     focusName = "Earth";
     break;
   case 4: xFocus = earthMoon.getPosition(t)[0]; yFocus = earthMoon.getPosition(t)[1]; zFocus = 0;
     focusName = "Moon";
     break;
   case 5: xFocus = mars.getPosition(t)[0]; yFocus = mars.getPosition(t)[1]; zFocus = 0;
     focusName = "Mars";
     break;
   case 6: xFocus = jupiter.getPosition(t)[0]; yFocus = jupiter.getPosition(t)[1]; zFocus = 0;
     focusName = "Jupiter";
     break;
 }
 cam2.lookAt(xFocus, yFocus, zFocus, cam2.getDistance(), 0);
}
void drawNotifications(){ // Put in camera HUD
  cam2.beginHUD();
  if(notifications.size() > 0){
    for(int i = notifications.size() - 1; i > -1; i--){
      fill(255, 255, 0, notificationTimes.get(i));
      text(notifications.get(i), 50, (20 * i) + 50);
      if(notificationTimes.get(i) <= 0){
        notifications.remove(i);
        notificationTimes.remove(i);
        continue;
      }
      notificationTimes.set(i, notificationTimes.get(i) - 2);
    }
  }
  cam2.endHUD();
}

void addNotification(String text, int time){
  notifications.add(text);
  notificationTimes.add(time);
}
// To see an accurate list of planet properties, go to: "https://nssdc.gsfc.nasa.gov/planetary/factsheet/[earth/moon/mars/sun]fact.html"
// Syntax: Planet Name = new Planet(distance, xEccentricity, yEccentricity, Size (x100)**, Speed (E = 1), Name); // **will not take effect if loading texture later.
// Syntax: Moon Name = new Moon(Parent, distance, xEccentricity, yEccentricity, Size (x100)**, Speed (E = 1), Name); // **will not take effect if loading texture later.


Planet mercury = new Planet(580, 0.2, 0, 0.2439, 1.6, "Mercury", 't');
Planet venus = new Planet(1000, 0, 0, 0.605, 1.17, "Venus", 't');
Planet earth = new Planet(1500, 0, 0, 0.637, 1, "Earth", 't');
Moon earthMoon = new Moon(earth, 38.44, 0.0, 0.0, 0.1737, 12, "Moon");
Planet mars = new Planet(2286, 0.0934, 0, 0.3390, 0.8082, "Mars", 't');
Planet jupiter = new Planet(7785, 0, 0, 6.6854, 0.44, "Jupiter", 'g');

//////////////////////////////////////////////////////////  SETUP  /////////////////////////////////////////////////////////////////////////

PeasyCam cam2;
void setup(){
  println("Starting...");
  size(1000, 1000, P3D); //1000, 1000   or   1925, 1120
  background(200);
  notifications = new ArrayList<String>();
  notificationTimes = new ArrayList<Integer>();
  addNotification("Welcome to Planets version " + version, 500);
  println("Initiating camera...");
  PeasyCam cam = new PeasyCam(this, 7000);
  cam.setMaximumDistance(8000);
  cam.setMinimumDistance(100);
  cam2 = cam;
  noStroke();
  println("Setting colours...");
  mercury.setColour(200, 200, 200);
  venus.setColour(200, 200, 0);
  earth.setColour(0, 200, 100);
  earthMoon.setColour(150, 150, 150);
  mars.setColour(200, 100, 0);
  jupiter.setColour(200, 150, 0);
  
  background(100);
  
  if(loadTextures){
    println("Loading textures...");
    
    println("  Earth");
    PImage loadTexture = loadImage("earth_flat_map.jpg");
    earth.setTexture(0.637, loadTexture);
    
    println("  Sun");
    sun = createShape(SPHERE, 69.57);
    loadTexture = loadImage("Sun.jpg");
    sun.setTexture(loadTexture);
    
    println("  Moon");
    loadTexture = loadImage("Moon.jpg");
    earthMoon.setTexture(0.1737, loadTexture);
    
    println("  Mercury");
    loadTexture = loadImage("Mercury.jpg");
    mercury.setTexture(0.2439, loadTexture);
    
    println("  Venus");
    loadTexture = loadImage("Venus.jpg");
    venus.setTexture(0.605, loadTexture);
    
    println("  Mars");
    loadTexture = loadImage("Mars.jpg");
    mars.setTexture(0.339, loadTexture);
    
    println("  Jupiter");
    loadTexture = loadImage("Jupiter.jpg");
    jupiter.setTexture(6.6854, loadTexture);
  } else {
    println("Texture loading skipped");
    sun = createShape(SPHERE, 69.57);
  }
  
  println("Done loading.");
}

//////////////////////////////////////////////////////////////////////  DRAW  ///////////////////////////////////////////////////////////////////////////
void draw(){
  if(!paused){
    t += timeSpeed;
  }
  checkKeys();
  focusPlanet();
  if(pPlanetFocus != planetFocus){
    addNotification("Focus changed to " + focusName, 150);
    pPlanetFocus = planetFocus;
  }
  background(0);
  
  shape(sun);
  
  pointLight(255, 255, 255, 0, 0, 0);
  ambientLight(200, 200, 200);
  
  pushMatrix();
  mercury.drawPlanet();
  popMatrix();
  pushMatrix();
  venus.drawPlanet();
  popMatrix();
  pushMatrix();
  earth.drawPlanet();
  popMatrix();
  pushMatrix();
  earthMoon.drawMoon(t);
  popMatrix();
  pushMatrix();
  mars.drawPlanet();
  popMatrix();
  pushMatrix();
  jupiter.drawPlanet();
  popMatrix();
  cam2.beginHUD();
  if(wasFPSLow){
    wasFPSLow = frameRate < 25;
  } else {
    if(frameRate < 20){
      addNotification("Low FPS. Zoom out or turn off orbit trails.", 200);
    }
    wasFPSLow = frameRate < 20; 
  }
  textSize(15);
  text("Object: " + focusName, 5, height - 5);
  //text(Earth.yearLength, width - 50, height - 35);
  text(round(frameRate) + " FPS", width - 50, height - 20);
  text("time tick: " + t, width - 150, height - 5);
  textSize(25);
  drawNotifications();
  cam2.endHUD();
  
}
