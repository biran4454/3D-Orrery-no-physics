class Object{ // Used as a template for planet and moon
  protected Object(float inputDist, float inputXEc, float inputYEc, float inputSize, float inputSpeed, String inputName){
     dist = inputDist;
     xEc = inputXEc;
     yEc = inputYEc;
     size = inputSize;
     speed = inputSpeed;
     name = inputName;
     texture = null;
     xPositions = new ArrayList<Float>();
     yPositions = new ArrayList<Float>();
  }
  protected PShape shape;
  protected PImage texture;
  protected float dist, xEc, yEc, x, y, size, speed;
  protected ArrayList<Float> xPositions, yPositions;
  public String name;
  protected int rColour, gColour, bColour;
  protected float yearDistance;
  protected float yearLength;
  
  protected float[] getPosition(float t){
    x = dist * planetDistanceScale * sin(t * speed + xEc);
    y = dist * planetDistanceScale * cos(t * speed + yEc);
    return new float[] {x, y};
  }
  protected void setColour(int r, int g, int b){
    rColour = r;
    gColour = g;
    bColour = b;
  }
  protected void setTexture(float inputSize, PImage loadTexture){
    shape = new PShape();
    size = inputSize;
    shape = createShape(SPHERE, size);
    texture = loadTexture;
  }
}
