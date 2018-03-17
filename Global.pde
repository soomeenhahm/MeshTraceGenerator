
void setupCamera() {

  cam= new PeasyCam(this, camCenter.x, camCenter.y, camCenter.z, 2000);        
  cam.setActive(true);

  //------------------------------------------------------camera angle change  
  /*cam.rotateX(-0.035);    //(-0.035007574)
   cam.rotateY(-0.7);      //(-0.7773035)
   cam.rotateZ(-0.03);     //(-0.029299712)
   
   cam.pan(0, 0);
   */
}

void setupPhysics() {
  physics= new VerletPhysics();
  Vec3D GRAVITY= new Vec3D (0, 0, -0.05);                  
  physics.addBehavior(new GravityBehavior(GRAVITY));

  //------------------------------------------------------wind
  //Vec3D wind= new Vec3D (1, 0, 0);
  //physics.addBehavior(new GravityBehavior(wind));

  physics.setDrag(0.05f);
  physics.setWorldBounds (new AABB(new Vec3D(camCenter.x, camCenter.y, camCenter.z), new Vec3D(wWidth/2, hHeight/2, dDepth/2)));
}



PrintWriter output;
PrintWriter output2;
void exportAgentTail() {
  if (blnPrintTail == true) {
    output = createWriter("output/" + timestamp() +"_SpringsS.txt");
    output2 = createWriter("output/" + timestamp() +"_SpringsE.txt");

    for (int i=0; i<physics.springs.size(); i++) {
      VerletSpring s= (VerletSpring) physics.springs.get(i);
      String st= s.a.x + "," + s.a.y + "," + s.a.z ;      
      output.println(st);

      String st2= s.b.x + "," + s.b.y + "," + s.b.z ;      
      output2.println(st2);
    }

    output.flush();
    output.close();

    output2.flush();
    output2.close();
    println("points have been exported");

    blnPrintTail= false;
  }
}

PrintWriter output3;
void exportMeshPts() { 
  if (blnPrintMeshPts == true) {
    output3 = createWriter("output/" + timestamp() +"_MeshPts.txt");

    for (int i=0; i<ParticlesMesh.size(); i++) {
      Particle pa= (Particle) ParticlesMesh.get(i);
      String st= pa.x + "," + pa.y + "," + pa.z ;      
      output3.println(st);
    }

    output3.flush();
    output3.close();

    println("mesh points have been exported");

    blnPrintMeshPts= false;
  }
}


void exportMeshFaces(Mesh mesh, String filename) { 

  PrintWriter output4;
  output4 = createWriter("output/" + timestamp() + "_" + filename+ ".obj");

  ArrayList allVertices= new ArrayList();
  for (int i=0; i<mesh.faces.size(); i++) {
    Face f= (Face) mesh.faces.get(i);
    String st= "f ";
    for (int j=0; j<f.vertices.size(); j++) {
      Particle pa= (Particle) f.vertices.get(j);
      allVertices.add(pa);
    }
  }


  for (int i=0; i< allVertices.size(); i++) {
    Particle pa= (Particle) allVertices.get (i);
    String st= "v " + pa.x + " " + pa.y + " " + pa.z;
    output4.println(st);
  }

  output4.println();
  for (int i=0; i<mesh.faces.size(); i++) {
    Face f= (Face) mesh.faces.get(i);
    String st= "f ";
    for (int j=0; j<f.vertices.size(); j++) {
      Particle pa= (Particle) f.vertices.get(j);
      int id= allVertices.indexOf(pa) +1;
      st= st + id + " ";
    }
    output4.println(st);
  }

  output4.flush();
  output4.close();

  println("mesh faces have been exported");
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}

