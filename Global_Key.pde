
boolean blnPrintTail= false;

boolean isRecord = false;
boolean blUpdatePhysics= true;
boolean blUpdateSprings= false;

boolean blReplicate= false;//

boolean blUpdateMouse= false;
boolean blLock= true;

boolean blnPrintMeshPts= false;
boolean blnMeshTrail= false;
boolean blnPrintMeshFaces= false;

boolean blDrawSprings= true;

boolean blPauseAgent= false;
boolean blGoToStart= false;

void keyPressed() {

  if (key == 'x') {
    blnPrintTail = !blnPrintTail;
  }

  if (key == 'i' ) {
    saveFrame("output/" + timestamp() + "_screen_" + frameCount + ".png");
    println ("screenshot is saved!");
  }  

  if (key == 'r' ) {
    isRecord = !isRecord;
  }

  if (key == 'p' ) {
    blUpdatePhysics = !blUpdatePhysics;
    println ("physics update is: " + blUpdatePhysics);
  }

  if (key == 's' ) {
    blUpdateSprings = !blUpdateSprings;
    println ("spring update is: " + blUpdateSprings);
  }

  if (key == 'l') {
    blLock = !blLock;
    LockUnlockParticles(ParticlesLock, blLock);
  }

  if (key == 'c') {
    blUpdateMouse= !blUpdateMouse;
    cam.setActive(!blUpdateMouse);
  }

  //if (key == 'm') {
  //blnPrintMeshPts= !blnPrintMeshPts;
  //}

  if (key == 'n') {
    blnMeshTrail= !blnMeshTrail;
  }

  if (key == 'f') {
    blnPrintMeshFaces= !blnPrintMeshFaces;
  }

  if (key == 'e') {
    mesh.faces.clear();
  }

  if (key == 'd') {
    blDrawSprings= !blDrawSprings;
  }

  if (key == ' ') {
    blPauseAgent= !blPauseAgent;
  }

  if (key == 'g') {
    blGoToStart= !blGoToStart;
  }

  if (key == ']') {
    intMeshInterval ++;
  }
  
  if (key == '['){
    intMeshInterval --;
  }
}

