public class Moon{ //Duplicate of Planet, with some adjustments
  public Moon(Planet inputParent, float inputDist, float inputXEc, float inputYEc, float inputSpeed, String inputName){
     dist = inputDist;
     xEc = inputXEc;
     yEc = inputYEc;
     speed = inputSpeed;
     name = inputName;
     texture = null;
     parent = inputParent;
  }
  public Moon(Planet inputParent, float inputDist, float inputXEc, float inputYEc, float inputSize, float inputSpeed, String inputName){
     dist = inputDist;
     xEc = inputXEc;
     yEc = inputYEc;
     size = inputSize;
     speed = inputSpeed;
     name = inputName;
     texture = null;
     parent = inputParent;
  }
  private PShape shape;
  private PImage texture;
  private Planet parent;
  private float dist;
  private float xEc;
  private float yEc;
  private float x;
  private float y;
  private float size;
  private float speed;
  private String name;
  private int rColour;
  private int gColour;
  private int bColour;
  
  public float[] getPosition(float t){
    x = dist * sin(t * speed + xEc);
    y = dist * cos(t * speed + yEc);
    return new float[] {x, y};
  }
  public void setColour(int r, int g, int b){ //Avoid messing the constructor up too much.
    rColour = r;
    gColour = g;
    bColour = b;
  }
  public void setTexture(float inputSize, PImage loadTexture){
    shape = new PShape();
    size = inputSize;
    shape = createShape(SPHERE, size);
    texture = loadTexture;
  }
  public void drawMoon(float t){
    x = dist * sin(t * speed + xEc) + parent.getPosition(t)[0];
    y = dist * cos(t * speed + yEc) + parent.getPosition(t)[1];
    translate(x, y);
    
    if(texture == null){
      fill(rColour, gColour, bColour);
      sphere(size * 10);
    }
    else{
      shape = createShape(SPHERE, size * 10);
      shape.setTexture(texture); // To avoid NPE. Any better suggestions?
      shape(shape);
    }
    
    translate(30, 30);
    textSize(100);
    text(name, 0, 0);
  }
}
