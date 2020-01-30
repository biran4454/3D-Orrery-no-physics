class Moon extends Object{ //Duplicate of Planet, with some adjustments
  public Moon(Planet inputParent, float inputDist, float inputXEc, float inputYEc, float inputSize, float inputSpeed, String inputName){
     super(inputDist, inputXEc, inputYEc, inputSize, inputSpeed, inputName); 
     parent = inputParent;
  }
  private Planet parent;
  
  public float[] getPosition(float t){
    x = dist * moonDistanceScale * sin(t * speed + xEc) + parent.getPosition(t)[0];
    y = dist * moonDistanceScale * cos(t * speed + yEc) + parent.getPosition(t)[1];
    return new float[] {x, y};
  }
  public void drawMoon(float t){
    x = dist * moonDistanceScale * sin(t * speed + xEc) + parent.getPosition(t)[0];
    y = dist * moonDistanceScale * cos(t * speed + yEc) + parent.getPosition(t)[1];
    if(orbitTrails){
      int a = 0;
      for(int i = xPositions.size() - 1; i > -1; i--){
        fill(moonTrailColour, 350 - (pow(2, timeSpeedIncrements)) * a);
        ellipse(xPositions.get(i), yPositions.get(i), 50, 50);
        a++;
      }
    }
    fill(255);
    if(!paused){
      xPositions.add(x);
      yPositions.add(y);
    }
    if(xPositions.size() > 350){
      while(xPositions.size() > 350){
        xPositions.remove(0);
        yPositions.remove(0);
      }
    }
    translate(x, y);
    
    if(texture == null){
      fill(rColour, gColour, bColour);
      sphere(size * moonSizeScale);
    }
    else{
      fill(255);
      shape = createShape(SPHERE, size * moonSizeScale);
      shape.setTexture(texture);
      shape(shape);
    }
    if(showLables){
      fill(rColour, gColour, bColour);
      translate(30, 30);
      textSize(100);
      text(name, 0, 0);
    }
  }
}
