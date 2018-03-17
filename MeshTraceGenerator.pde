//written by Soomeen Hahm, Nov 2014 
//written for the Term 1, Scripting Workshop, Research Cluster 6, GAD, Bartlett, UCL
//Copyright (c) 2014 SOOMEENHAHM.com, London UK 


//To Do:
// *. Separate vertical & horizontal
// 3. Able to export as mesh (same vertex order?)
// *. check through particles to minimise connection - triangle
// *. replication behaviour to be better and natural
// *. draw points
// clean up duplication
// add new agents at the middle of spring


//when a particle has less then 3 connections then choose one of its spring to add a particle in the middle of that spring
//analyse (longer then expected then tension, shorter then compression)



import toxi.geom.*;
import toxi.geom.mesh.*;
import peasy.*;
import toxi.physics.*;
import toxi.physics.constraints.*;
import toxi.physics.behaviors.*;
import plethora.core.*;

import java.util.Calendar;

//world size
int wWidth= 1600;     //1280
int hHeight= 1200;     //720
int dDepth = 1600;    //600

//camera
PeasyCam cam;
Vec3D camCenter= new Vec3D (0, 0, 0);

//spring
float restLengthScale= 1;   //initial
float springStrength= 0.1;   //initial

float scBlack= 1; //restLengthScale for black value
float scRed= 0.5; //restLengthScale for red value

//physics
VerletPhysics physics;
ArrayList SpringCollection; 
ArrayList SpringRLSCollection; 
ArrayList ParticlesLock; 
ArrayList ParticlesMesh;
ArrayList MeshDef;

Mesh mesh;
Mesh mesh_org;

int intMeshInterval= 100; //create new mesh tail in every nth frame


ArrayList agentGuidCrv;
ArrayList agentGuidCrv2;
ArrayList agentGuidCrv3;

myAgent al;
myAgent al2;
myAgent al3;

void setup() {
  size(1280, 720, P3D);
  smooth();
  background(255);

  setupCamera();
  setupPhysics();
  setupImportSpring();

  mesh= new Mesh();
  mesh.setupMesh();

  mesh_org= new Mesh();
  mesh_org.setupMesh();
  mesh_org.ImportTextMeshDef_org("input/MeshDef.txt");


  //========================================================
  agentGuidCrv= ImportText_guide("input/GuideCrv.txt");
  agentGuidCrv2= ImportText_guide("input/GuideCrv2.txt");
    agentGuidCrv3= ImportText_guide("input/GuideCrv3.txt");


  Particle pl= (Particle) ParticlesLock.get(0);
  pl.lock();
  al= new myAgent(this, pl);

  Particle pl2= (Particle) ParticlesLock.get(1);
  pl2.lock();
  al2= new myAgent(this, pl2);
  
    Particle pl3= (Particle) ParticlesLock.get(2);
  pl3.lock();
  al3= new myAgent(this, pl3);
  //========================================================
}


void draw() {
  background(255);

  //drawOrigin();
  drawGuideCrv(agentGuidCrv);
  drawGuideCrv(agentGuidCrv2);
   drawGuideCrv(agentGuidCrv3);

  if (blUpdateSprings) {
    updateSprings(SpringCollection);
    blUpdateSprings= false;
  }

  if (blUpdatePhysics) {
    physics.update();
  }

  if (blDrawSprings) drawSpring(SpringCollection);
  drawLockedParticles(ParticlesLock, blLock);
  //drawParticle(color (155));

  mesh.update();
  strokeWeight(1);
  stroke(0);
  fill(200, 200, 200);
  mesh.render();

  strokeWeight(1);
  stroke(0);
  fill(155, 155, 155);
  mesh_org.render();

  drawBox();

  //followMouse();
  if (blUpdatePhysics) {
    //========================================================
    if (!blGoToStart) al.alignmentCall(agentGuidCrv, 60, 10); 
    if (!blPauseAgent) al.update();
    al.maxspeed = 0.5;
    al.render();

    if (!blGoToStart) al2.alignmentCall(agentGuidCrv2, 60, 10); 
    if (!blPauseAgent) al2.update();
    al2.maxspeed = 0.5;
    al2.render();
    
       if (!blGoToStart) al3.alignmentCall(agentGuidCrv3, 60, 10); 
    if (!blPauseAgent) al3.update();
    al3.maxspeed = 0.5;
    al3.render();


    if (blGoToStart) {
      myAgent cs= (myAgent) agentGuidCrv.get(0);
      al.arrive(cs.loc);
    }

    if (blGoToStart) {
      myAgent cs= (myAgent) agentGuidCrv2.get(0);
      al2.arrive(cs.loc);
      
      
    }
    
        if (blGoToStart) {
      myAgent cs= (myAgent) agentGuidCrv3.get(0);
      al3.arrive(cs.loc);
    }
    //===
    //========================================================
  }

  //Particle pl= (Particle) ParticlesLock.get(0);

  //pl.lock();
  //pl.y= pl.y+10;
  //pl.unlock();


  if (isRecord) saveFrame ("output/image" + frameCount + ".png");
  exportAgentTail();
  exportMeshPts();

  if (blnPrintMeshFaces == true) {
    exportMeshFaces(mesh, "MeshFaces");
    exportMeshFaces(mesh_org, "MeshFaces_org");
    blnPrintMeshFaces= false;
  }
  
  println(intMeshInterval);
}



//------------------------------------------------------------------------------------------------------------
//Draw:
//------------------------------------------------------------------------------------------------------------

void drawBox() {
  stroke(200);                
  strokeWeight(1);
  noFill();
  box(wWidth, hHeight, dDepth);
}

void drawParticle(color c) {
  for (int i=0; i< physics.particles.size(); i++) {
    Particle p= (Particle) physics.particles.get (i);
    stroke(c);
    strokeWeight(6);
    point (p.x, p.y, p.z);
  }
}


void drawLockedParticles(ArrayList ParticlesLock, boolean blLock) {
  if (blLock) {
    for (int i = 0; i < ParticlesLock.size(); i ++) {
      Particle pa= (Particle) ParticlesLock.get(i);

      stroke(0);                 
      strokeWeight(10);
      point (pa.x, pa.y, pa.z);
    }
  }
}


void drawSpring(ArrayList SpringCollection) {

  for (int i=0; i< SpringCollection.size(); i++) {
    VerletSpring s= (VerletSpring) SpringCollection.get (i);
    Vec3D rls= (Vec3D) SpringRLSCollection.get(i);

    float tc= map (rls.x, 0, 1, 0, 255);

    stroke(tc, 0, 0);
    strokeWeight(1);
    line(s.a.x, s.a.y, s.a.z, s.b.x, s.b.y, s.b.z);
  }
}

void drawOrigin() {
  strokeWeight(1);
  stroke(0);
  line(0, 0, 0, 100, 0, 0);
  strokeWeight(3);
  line(0, 0, 0, 0, 100, 0);
  strokeWeight(5);
  line(0, 0, 0, 0, 0, 100);
}


void drawGuideCrv(ArrayList agentGuidCrv) {
  if (agentGuidCrv.size() >0) {
    for (int i=0; i<agentGuidCrv.size(); i++) {
      myAgent a= (myAgent) agentGuidCrv.get(i);
      a.render();
    }
  }
}

//------------------------------------------------------------------------------------------------------------
//Update:
//------------------------------------------------------------------------------------------------------------

void updateSprings(ArrayList SpringCollection) {
  for (int i=0; i< SpringCollection.size(); i++) {
    VerletSpring s= (VerletSpring) SpringCollection.get (i);
    Vec3D rls= (Vec3D) SpringRLSCollection.get(i);
    float restLengthScalet= rls.x; 
    float restLengtht= s.getRestLength();
    s.setRestLength(restLengtht * restLengthScalet);
  }
}

void AddParticleAttraction() {
  for (int i = 0; i < physics.particles.size(); i ++) {
    VerletParticle pa= (VerletParticle) physics.particles.get(i);
    physics.addBehavior(new AttractionBehavior(pa, 100, -3f, 0.01f));
  }
}

void LockUnlockParticles(ArrayList ParticlesLock, boolean blLock) {
  for (int i = 0; i < ParticlesLock.size(); i ++) {
    Particle pa= (Particle) ParticlesLock.get(i);

    if (blLock) {
      pa.lock();
    }
    else {
      pa.unlock();
    }
  }
}


void followMouse() {
  if (blUpdateMouse) {
    if (mousePressed) {
      Particle pl= (Particle) ParticlesLock.get(0);

      pl.lock();
      pl.x= mouseX;
      pl.y= mouseY;
      pl.unlock();
    }
  }
}


ArrayList ImportText_guide(String fileName) {
  ArrayList collection= new ArrayList();
  String lines[]= loadStrings(fileName);
  for (int i=0; i<lines.length-1; i++) {
    float values[]= float(lines[i].split(","));
    Vec3D loc= new Vec3D(values[0], values[1], values[2]);
    myAgent pa= new myAgent(this, loc);

    float values2[]= float(lines[i+1].split(","));
    Vec3D loc2= new Vec3D(values2[0], values2[1], values2[2]);
    Vec3D vel= loc2.sub(loc);
    pa.vel= vel;

    collection.add(pa);
  }

  return collection;
}

