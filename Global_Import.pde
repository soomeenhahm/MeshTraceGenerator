void setupImportSpring() {
  SpringCollection= new ArrayList();
  ArrayList Loc_Start= ImportText("input/StartPts.txt");
  ArrayList Loc_End= ImportText("input/EndPts.txt");
  SpringRLSCollection= ImportText("input/RestLengthSc.txt");
  setupStructure_First(Loc_Start, Loc_End, SpringRLSCollection, SpringCollection, 1, 0.1);
  AddParticleAttraction();

  ParticlesLock= ImportTextLock("input/LockPts.txt");
}



ArrayList ImportText(String fileName) {
  ArrayList collection= new ArrayList();
  String lines[]= loadStrings(fileName);
  for (int i=0; i<lines.length; i++) {
    float values[]= float(lines[i].split(","));
    Vec3D loc= new Vec3D(values[0], values[1], values[2]);

    collection.add(loc);
  }

  return collection;
}



ArrayList ImportTextLock(String fileName) {
  ArrayList collection= new ArrayList();
  String lines[]= loadStrings(fileName);
  for (int i=0; i<lines.length; i++) {
    float values[]= float(lines[i].split(","));
    Vec3D loc= new Vec3D(values[0], values[1], values[2]);
    //loc.scaleSelf(1);

    for (int j= 0; j < physics.particles.size(); j ++) {
      Particle pa  = (Particle)physics.particles.get(j);
      float dist= loc.distanceTo (pa);

      if (dist < 0.01) {
        collection.add(pa);
      }
    }
  }

  return collection;
}




void setupStructure_First(ArrayList collectionS, ArrayList collectionE, ArrayList collectionC, ArrayList SpringCollection, float restLengthScale, float springStrength) {
  Vec3D locS= (Vec3D) collectionS.get(0);
  Vec3D locE= (Vec3D) collectionE.get(0);
  Vec3D rls= (Vec3D) collectionC.get(0);
  float ct= map (rls.x, 0, 1, 0, 255);
  color c= color (ct, 0, 0);
  Particle pS= new Particle(locS);
  physics.addParticle(pS);
  Particle pE= new Particle(locE);
  physics.addParticle(pE);
  float dist= locS.distanceTo(locE);
  VerletSpring s= new VerletSpring(pS, pE, dist*restLengthScale, springStrength);
  physics.addSpring(s);
  SpringCollection.add(s);


  for (int i= 1; i < collectionS.size(); i++) {
    locS= (Vec3D) collectionS.get(i);
    pS= testDuplicate(locS);

    locE= (Vec3D) collectionE.get(i);
    pE= testDuplicate(locE);

    rls= (Vec3D) collectionC.get(i);
    ct= map (rls.x, 0, 1, 0, 255);
    c= color (ct, 0, 0);

    dist= locS.distanceTo(locE);
    s= new VerletSpring(pS, pE, dist*restLengthScale, springStrength);
    physics.addSpring(s);
    SpringCollection.add(s);
  }
}





void setupStructure(ArrayList collectionS, ArrayList collectionE, ArrayList SpringCollection, float restLengthScale, float springStrength) {
  Vec3D locS;
  Vec3D locE;
  Particle pS;
  Particle pE;
  float dist;
  VerletSpring s;

  for (int i= 0; i < collectionS.size(); i++) {
    locS= (Vec3D) collectionS.get(i);
    pS= testDuplicate(locS);

    locE= (Vec3D) collectionE.get(i);
    pE= testDuplicate(locE);

    dist= locS.distanceTo(locE);
    s= new VerletSpring(pS, pE, dist*restLengthScale, springStrength);
    physics.addSpring(s);
    SpringCollection.add(s);
  }
}




Particle testDuplicate(Vec3D locS) {
  boolean blnSame= false;
  Particle pS= new Particle(locS);
  for (int i=0; i< physics.particles.size(); i++) {
    Particle pOther= (Particle) physics.particles.get (i);
    //if ((pOther.x == locS.x) && (pOther.y == locS.y)  && (pOther.z == locS.z)) {
    if (pOther.distanceTo(locS) < 0.1) { 
      blnSame= true;
      pS= pOther;
    }
  }

  if (blnSame == false) {
    physics.addParticle(pS);
  }

  return pS;
}

