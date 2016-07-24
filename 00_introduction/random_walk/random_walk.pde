void setup() {
  size(800, 600);
  background(255);
  
  startX = width / 2;
  startY = height / 2;
}

float startX;
float startY;
int rand;

void draw() {
  point(startX, startY);
  
  rand = (int)random(100);
  switch (rand % 4) {
    case 0:
      startX += 1;
      break;
    case 1:
      startX -= 1;
      break;
    case 2:
      startY += 1;
      break;
    case 3:
      startY -= 1;
      break;
    default:
      break;
    }
}