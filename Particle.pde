
class Particle extends VerletParticle {
  Particle(Vec3D _loc) {
    super(_loc);

    //physics.addBehavior(new AttractionBehavior(this, 100, -3f, 0.01f));
  }

  void delete() {
    physics.particles.remove(this);

    stroke(0, 255, 0);
    strokeWeight(20);
    point(this.x, this.y, this.z);
  }
}

