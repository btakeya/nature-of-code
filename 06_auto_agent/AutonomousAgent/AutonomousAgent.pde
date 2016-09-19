void setup() {
  size(800, 600);
  background(255);
  
  id = 0;
  vehicles = new ArrayList<Vehicle>();
}

int id;

ArrayList<Vehicle> vehicles;  
PVector moveX;

float marginX = 50;
float marginY = 50;

void mouseReleased() {
  Vehicle v = new Vehicle(mouseX, mouseY, id);
  vehicles.add(v);
  id += 1;
}

void draw() {
  background(255);
  
  /* Margin */
  line(0, marginY, width, marginY);
  line(0, height - marginY, width, height - marginY);
  line(marginX, 0, marginX, height);
  line(width - marginX, 0, width - marginX, height);
  
  for (Vehicle v : vehicles) {
    v.seek(new PVector(mouseX, mouseY));
    v.update();
    v.display();
  }
}

class Vehicle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float size;
  
  float forceLimit;
  float speedLimit;
  
  int _id;
  
  Vehicle(float x, float y, int id) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0); 
    acceleration = new PVector(0, 0);
    
    size = 3.0;
    
    forceLimit = 0.1;
    speedLimit = 5.0;
    
    _id = id;
  }
  
  int getId() {
    return _id;
  }
  
  void update() {
    avoidWall();
    velocity.add(acceleration);
    velocity.limit(speedLimit);
    
    position.add(velocity);
    acceleration.mult(0);
  }
  
  void avoidWall() {
    if (position.x < marginX) {
      PVector desired = new PVector(speedLimit, velocity.y);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(forceLimit);
      applyForce(steer);
    } else if (position.x > width - marginX) {
      PVector desired = new PVector(-speedLimit, velocity.y);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(forceLimit);
      applyForce(steer);
    }
    
    if (position.y < marginY) {
      PVector desired = new PVector(velocity.x, speedLimit);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(forceLimit);
      applyForce(steer);
    } else if (position.y > height - marginY) {
      PVector desired = new PVector(velocity.x, -speedLimit);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(forceLimit);
      applyForce(steer);
    }
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    float distance = desired.mag();
    float adjustedSpeed = speedLimit;
    
    if (distance <= 5) adjustedSpeed = 0; /* Arrived */
    else if (distance <= 100) adjustedSpeed *= (distance / 100); /* Around target */
    
    desired.normalize();
    desired.mult(adjustedSpeed);
    
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
  
  boolean equals(Vehicle other) {
    boolean isSameHashCode = this.hashCode() == other.hashCode();
    boolean isSameId = this.getId() == other.getId();
    return isSameHashCode && isSameId;
  }
}