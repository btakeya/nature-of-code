import java.util.*;

ArrayList<ParticleSystem> particleSystems;
PVector startPos;
int particleType;
final int MAX_SIZE = 1000;

void setup() {
  size(1024, 786);
  
  startPos = new PVector(width / 2, height / 4);
  particleSystems = new ArrayList<ParticleSystem>();
  particleType = ParticleSystem.TYPE_CIRCLE;
}

void draw() {
  background(0);
  
  Iterator<ParticleSystem> psIterator = particleSystems.iterator();
  while (psIterator.hasNext()) {
    ParticleSystem currentSystem = psIterator.next();
    currentSystem.run();
  }
}

void mousePressed() {
  ParticleSystem newPs = new ParticleSystem(new PVector(mouseX, mouseY));
  particleSystems.add(newPs);
  particleType = (particleType + 1) % 3;
}

class ParticleSystem {
  private final static int TYPE_CIRCLE = 0;
  private final static int TYPE_SQUARE = 1;
  private final static int TYPE_TRIANGLE = 2;

  ArrayList<Particle> particles;
  PVector origin;
  int type = 0;
  
  ParticleSystem(PVector pos) {
    origin = pos;
    particles = new ArrayList<Particle>();
    type = particleType;
  }
  
  void add(Particle p) {
    particles.add(p);
  }
  
  private boolean isFull() {
    return particles.size() < MAX_SIZE;
  }
  
  void run() {
    if (isFull()) {
      Particle p = null;
      if (type == TYPE_SQUARE) {
        p = new SquareParticle(origin);
      } else if (type == TYPE_TRIANGLE) {
        p = new TriangleParticle(origin);
      } else { /* TYPE_CIRCLE or else */
        p = new CircleParticle(origin);
      }
      particles.add(p);
    }
      
    Iterator<Particle> ip = particles.iterator();
    while (ip.hasNext()) {
      Particle p = ip.next();
      p.update();
      if (p != null && p.isAlive()) {
        p.display();
      } else {
        ip.remove();
      }
    }
  }
}

abstract class Particle {
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

class SquareParticle extends Particle {
  SquareParticle(PVector pos) {
    super(pos);
  }
  
  void display() {
    float theta = map(pos.x, 0, width, 0, TWO_PI * 2);
    
    rectMode(CENTER);
    fill(200, lifetime);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    rect(0, 0, 8, 8);
    popMatrix(); 
  }
}

class TriangleParticle extends Particle {
  TriangleParticle(PVector pos) {
    super(pos);
  }
  
  void display() {
    float theta = map(pos.x, 0, width, 0, TWO_PI);
    
    fill(200, lifetime);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    triangle(0, 0, 4, -sqrt(48), 8, 0);
    popMatrix();
  }
}

class CircleParticle extends Particle {
  CircleParticle(PVector pos) {
    super(pos);
  }
}