void setup()
{
  size(400, 300);
  background(255);
}

int RADIUS = 30;

void draw()
{
  int x = mouseX;
  int y = mouseY;
  
  background(255);
  
  fill(0);
  ellipse(x, y, RADIUS, RADIUS);
}