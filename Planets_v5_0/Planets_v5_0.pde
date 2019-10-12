/*
* Created by Biran4454
* 2019
*/
/*
Notes:

  Controls:
    Left-click: rotate
    Right-click / mouse wheel: zoom
    Middle-click: pan

*/

import peasy.*;
PeasyCam cam;

// Insert classes here to have only one file / tab.


// PLEASE NOTE: Values are correct, but I may have moved the decimal point on some so it is possible to see the planets.
// To see an accurate list of planet properties, go to: "https://nssdc.gsfc.nasa.gov/planetary/factsheet/[your planet name here]fact.html"
// Syntax: Planet Name = new Planet(distance, xEccentricity, yEccentricity, Size (x100)**, Speed (E = 1), Name); // **ommitted if loading texture later
Planet Earth = new Planet(1500, 0.1, 0.1, 6.371, 1, "Earth"); //Assumes 0.1 eccentricity
Planet Mars = new Planet(2286, 0.0934, 0, 3.3895, 0.8082, "Mars");
// Syntax: Moon Name = new Moon(Parent, distance, xEccentricity, yEccentricity, Size (x100)**, Speed (E = 1), Name); // **ommitted if loading texture later
Moon EarthMoon = new Moon(Earth, 384, 0.0, 0.0, 1.737, 0.34, "Moon");

void setup(){
  size(1000, 1000, P3D);
  cam = new PeasyCam(this, 500);  
  //cam.setMaximumDistance(500);
  cam.setMinimumDistance(50);
  noStroke();
  PImage loadTexture = loadImage("earth_flat_map.jpg");
  Earth.setTexture(6.371, loadTexture);
}


float t = 0;

void draw(){
  t += 0.01;
  background(0);
  fill(255, 255, 100);
  sphere(69.57);
  
  Earth.setColour(0, 200, 100);
  Mars.setColour(200, 100, 0);
  EarthMoon.setColour(200, 200, 200);
  pushMatrix();
  beginShape();
  Earth.drawPlanet();
  endShape();
  popMatrix();
  pushMatrix();
  Mars.drawPlanet();
  popMatrix();
  pushMatrix();
  EarthMoon.drawMoon(t);
  popMatrix();
  println("Framerate: " + int(frameRate));
}
