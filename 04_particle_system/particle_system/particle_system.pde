import java.util.*;

ArrayList<ParticleSystem> particleSystems;
PVector startPos;

void setup() {
  size(1024, 786);
  
  startPos = new PVector(width / 2, height / 4);
  particleSystems = new ArrayList<ParticleSystem>();
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
}

int MAX_SIZE = 1000;
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  
  ParticleSystem(PVector pos) {
    origin = pos;
    particles = new ArrayList<Particle>();
  }
  
  void add(Particle p) {
    particles.add(p);
  }
  
  private boolean isFull() {
    return particles.size() < MAX_SIZE;
  }
  
  void run() {
    if (isFull()) {
      particles.add(new Particle(origin));
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