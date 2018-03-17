class myAgent extends Ple_Agent {
  PApplet p5;

  myAgent(PApplet _p5, Vec3D _loc) {
    super (_p5, _loc);
  }

  void render() {
    stroke(155);
    strokeWeight(4);
    point(loc.x, loc.y, loc.z);

    strokeWeight(1);
    Vec3D loc_next= loc.add(vel);
    line(loc.x, loc.y, loc.z, loc_next.x, loc_next.y, loc_next.z);
  }
}

