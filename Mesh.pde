class Mesh {
  ArrayList vertices;
  ArrayList faces;

  Mesh() {
    vertices= new ArrayList();
    faces= new ArrayList();
  }

  void update() {
    ////////////////////////////////////////////////////////
    if (blnMeshTrail) {
      if (frameCount % intMeshInterval ==0) {
        ImportTextMeshDef("input/MeshDef.txt");
      }
    }
  }

  void render() {
    for (int i=0; i< faces.size(); i++) {
      Face f= (Face) faces.get(i);
      f.render();
    }
  }

  void setupMesh() {
    vertices= ImportTextLock("input/MeshPts.txt");
    //ImportTextMeshDef("input/MeshDef.txt");
  }

  void ImportTextMeshDef(String fileName) {
    ArrayList collection= new ArrayList();
    String lines[]= loadStrings(fileName);
    for (int i=0; i<lines.length; i++) {
      int values[]= int(lines[i].split(";"));
      Face f= new Face();
      for (int j=0; j< values.length; j++) {
        Particle pa  = (Particle)vertices.get(values[j]);
        Particle pt= new Particle(pa);
        //pt.delete();
        f.vertices.add(pt);
        //f.vertices.add(pa); //////////////////////////////////
      }
      faces.add(f);
    }
  }

  void ImportTextMeshDef_org(String fileName) {
    ArrayList collection= new ArrayList();
    String lines[]= loadStrings(fileName);
    for (int i=0; i<lines.length; i++) {
      int values[]= int(lines[i].split(";"));
      Face f= new Face();
      for (int j=0; j< values.length; j++) {
        Particle pa  = (Particle)vertices.get(values[j]);
        Particle pt= new Particle(pa);
        //pt.delete();
        //f.vertices.add(pt);
        f.vertices.add(pa); //////////////////////////////////
      }
      faces.add(f);
    }
  }
}


class Face {
  ArrayList vertices;

  Face() {
    vertices= new ArrayList();
  }

  void render() {
    beginShape();
    for (int i=0; i< vertices.size(); i++) {
      Particle pa  = (Particle)vertices.get(i);
      vertex(pa.x, pa.y, pa.z);
    }
    endShape(CLOSE);
  }
}

