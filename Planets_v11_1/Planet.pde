class Planet extends Object{
  public Planet(float inputDist, float inputXEc, float inputYEc, float inputSize, float inputSpeed, String inputName, char inputType){
     super(inputDist, inputXEc, inputYEc, inputSize, inputSpeed, inputName);
     type = inputType;
  }
  private char type;
  
  public float[] getPosition(float t){
    x = dist * planetDistanceScale * sin(t * speed + xEc);
    y = dist * planetDistanceScale * cos(t * speed + yEc);
    return new float[] {x, y};
  }
  public void drawPlanet(){
    x = dist * planetDistanceScale * sin(t * speed + xEc);
    y = dist * planetDistanceScale * cos(t * speed + yEc);
    if(orbitTrails){
      int a = 0;
      for(int i = xPositions.size() -1; i > -1; i--){
        fill(planetTrailColour, 200 - (pow(2, timeSpeedIncrements)) * a); // TODO: Sort it so it is the right colours.
        ellipse(xPositions.get(i), yPositions.get(i), 75, 75);
        a++;
      }
    }
    fill(255);
    if(!paused){
      xPositions.add(x);
      yPositions.add(y);
    }
    if(xPositions.size() > 200){
      while(xPositions.size() > 200){
        xPositions.remove(0);
        yPositions.remove(0);
      }
    }
    translate(x, y);
    
    if(texture == null){
      fill(rColour, gColour, bColour);
      if(type == 'g'){
        sphere(size * planetSizeScale * gasSizeScale);
      }
      else{
        sphere(size * planetSizeScale);
      }
    }
    else{
      if(type == 'g'){
        shape = createShape(SPHERE, size * planetSizeScale);
      }
      else{
        shape = createShape(SPHERE, size * planetSizeScale * gasSizeScale);
      }
      fill(255);
      shape.setTexture(texture);
      shape(shape);
    }
    if(showLables){
      fill(rColour, gColour, bColour);
      translate(30, 30);
      textSize(100);
      text(name, 0, 0);
    }
    yearDistance = dist * 2 * PI;
    yearLength = yearDistance * (t * speed + xEc); // TODO: Fix time to go one unit.
    //if(x >= -10 && x <= 10){
    //   yearLength = t - yearLength;
    //}
  }
}
