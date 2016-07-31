class Vector2D {
  float x;
  float y;
  
  Vector2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Vector2D inv() {
    return new Vector2D(-this.x, -this.y);
  }
  
  Vector2D add(Vector2D otherVector) {
    return new Vector2D(this.x + otherVector.x, this.y + otherVector.y);
  }
  
  Vector2D sub(Vector2D otherVector) {
    return add(otherVector.inv());
  }
  
  Vector2D mul(float factor) {
    return new Vector2D(this.x * factor, this.y * factor);
  }
  
  Vector2D div(float factor) {
    return mul(1 / factor);
  }
  
  float mag() {
    return sqrt(this.x * this.x + this.y * this.y);
  }
  
  Vector2D normalize() {
    return div(mag());
  }
}

void drawAsPositionVector(Vector2D vector) {
  Vector2D zeroVector = new Vector2D(0, 0);
  drawLine(zeroVector, vector);
}

void drawLine(Vector2D start, Vector2D end) {
  line(start.x, start.y, end.x, end.y);
}

void setup() {
  size(600, 400);
  background(255);
}

void draw() {
  Vector2D v1 = new Vector2D(30, 40);
  Vector2D v2 = new Vector2D(50, 70);
  
  drawAsPositionVector(v1);
  drawAsPositionVector(v2);
  
  drawAsPositionVector(v1.add(v2));
  
  drawLine(v1, v2);
}