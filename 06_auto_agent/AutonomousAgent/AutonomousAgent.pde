void setup() {
  size(800, 600);
  background(255);
  
  id = 0;
  vehicles = new ArrayList<Vehicle>();
  
  path = new Path();
}

int id;

Path path;

ArrayList<Vehicle> vehicles;  
PVector moveX;

float marginX = 50;
float marginY = 50;

void mouseReleased() {
  Vehicle v = new Vehicle(mouseX, mouseY, id);
  vehicles.add(v);
  id += 1;
}

import java.util.*;

void draw() {
  background(255);
  
  path.display();
  
  Iterator<Vehicle> vIter = vehicles.iterator();
  //v.seek(new PVector(mouseX, mouseY));
  while (vIter.hasNext()) {
    Vehicle v = vIter.next();
    v.follow(path);
    v.update();
    
    if (v.position.x < 0 || width < v.position.x) {
      vIter.remove();
    } else if (v.position.y < 0 || height < v.position.y) {
      vIter.remove();
    } else {
      v.display();
    }
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
  
  void follow(Path path) {
    PVector predict = velocity.copy();
    predict.normalize();
    predict.mult(25);
    PVector futurePosition = PVector.add(position, predict);
    
    PVector a = path.start;
    PVector b = path.end;
    PVector normalPoint = getNormalPoint(futurePosition, a, b);
    
    PVector direction = PVector.sub(b, a);
    direction.normalize();
    direction.mult(10);
    PVector target = PVector.add(normalPoint, direction);
    
    float distance = PVector.dist(normalPoint, futurePosition);
    if (distance > path.radius) {
      seek(target);
    }
  }
  
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    PVector ap = PVector.sub(p, a);
    PVector ab = PVector.sub(b, a);
    
    ab.normalize();
    ab.mult(ap.dot(ab));
    
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
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

class Path {
  PVector start;
  PVector end;
  
  float radius;
  
  Path() {
    radius = 20;
    start = new PVector(0, height / 3);
    end = new PVector(width, 2 * height / 3);
  }
  
  void display() {
    strokeWeight(radius * 2);
    stroke(0, 100);
    line(start.x, start.y, end.x, end.y);
    strokeWeight(1);
    stroke(0);
    line(start.x, start.y, end.x, end.y);
  }
}