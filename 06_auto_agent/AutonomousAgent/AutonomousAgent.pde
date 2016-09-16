void setup() {
  size(800, 600);
  background(255);
  v = new Vehicle(width/2.0, height/2.0);
}

Vehicle v;  
PVector moveX;

void draw() {
  background(255);
  v.seek(new PVector(mouseX, mouseY));
  v.update();
  v.display();
}

class Vehicle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float size;
  
  float forceLimit;
  float speedLimit;
  
  Vehicle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0); 
    acceleration = new PVector(0, 0);
    
    size = 3.0;
    
    forceLimit = 0.1;
    speedLimit = 5.0;
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(speedLimit);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(speedLimit);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(forceLimit);
    applyForce(steer);
  }
  
  void display() {
    float theta = velocity.heading() + PI / 2;
    
    fill(255, 255/2.0, 255/2.0/2.0);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(0, -size * 2);
    vertex(-size, size * 2);
    vertex(size, size * 2);
    endShape(CLOSE);
    popMatrix();
  }
}