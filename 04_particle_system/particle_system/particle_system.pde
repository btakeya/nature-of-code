Particle p;
PVector startPos;

void setup() {
  size(1024, 786);
  
  startPos = new PVector(width / 2, height / 4);
  p = new Particle(startPos);
}

void draw() {
  background(0);
  
  p.update();
  if (p != null && p.isAlive()) {
    p.display();
  } else {
    p = new Particle(startPos);
  }
}

class Particle {
  PVector pos;
  PVector velo;
  PVector accel;
  
  float lifetime;
  
  Particle(PVector pos) {
    this.pos = new PVector(pos.x, pos.y);
    this.velo = new PVector(random(-5, 5), random(-10, 0));
    this.accel = new PVector(0, 0.98);
    this.lifetime = 255;
  }
  
  void update() {
    velo.add(accel);
    pos.add(velo);
    
    lifetime -= 8.0;
  }
  
  void display() {
    stroke(0, lifetime);
    fill(200, lifetime);
    ellipse(pos.x, pos.y, 7, 7);
  }
  
  boolean isAlive() {
    return lifetime > 0 ? true : false;
  }
}