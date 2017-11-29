/*

Velocity determines size of ellipse and duration of fade
Age (how long ago note was played) determines opacity of color
Position currently randomized

Color --> ???? (PITCH)

*/

class Note {
   
  int age, maxAge, size;
  int channel, velocity, pitch;
  PVector position;
  boolean dying = false;
  color displayColor;
  TriangleDeltas tDeltas;
  Note previous;
  
  Note(int channel_, int pitch_, int velocity_, float x_, float y_) {
    this.channel = channel_;
    this.pitch = pitch_;
    this.velocity = velocity_;
    
    this.age = 0;  // age starts at 0
    this.position = new PVector(x_, y_);
    this.size = velocity_;  // size is velocity
    
    // scale velocity to a lifespan (arbitrarily) (this determines # frames note takes to fade)
    this.maxAge = (int) ((float) velocity_ / 100.0f) * 100 + minimumFrameLifeSpan;
    
    this.displayColor = scalePitchToColor(this.pitch);   
    
    if (!ellipseRepresentation) {
      // INIT RANDOM DELTAS
      float dx1, dy1, dx2, dy2, dx3, dy3;
      
      dx1 = triangleScale * random((float) -velocity, (float) velocity);
      dy1 = triangleScale * random((float) -velocity, (float) velocity);
      dx2 = triangleScale * random((float) -velocity, (float) velocity);
      dy2 = triangleScale * random((float) -velocity, (float) velocity);
      dx3 = triangleScale * random((float) -velocity, (float) velocity);
      dy3 = triangleScale * random((float) -velocity, (float) velocity);
      
      this.tDeltas = new TriangleDeltas(dx1, dy1, dx2, dy2, dx3, dy3);
    }
  }
  
  // update note age and features
  void update() {
    if (this.dying) {
      this.age++;
      if (risingEffect) {
        this.position.y -= rateOfAscent;
      }
    }
  }
  
  // display node on canvas
  void display() {
    // fade graphic as dying
    float alpha = scaleVal((float) this.age, 0, this.maxAge, 255, 0);
    fill(this.displayColor, alpha);
    
    if (ellipseRepresentation) {
      ellipse(this.position.x, this.position.y, this.size, this.size);
    } else {
      // get all vertices
      PVector v1 = new PVector(this.position.x + this.tDeltas.delta1.x, this.position.y + this.tDeltas.delta1.y);
      PVector v2 = new PVector(this.position.x + this.tDeltas.delta2.x, this.position.y + this.tDeltas.delta2.y);
      PVector v3 = new PVector(this.position.x + this.tDeltas.delta3.x, this.position.y + this.tDeltas.delta3.y);
      
      triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
    }
    
    if (showConnections) {
      if (this.previous != null && this.previous.age < this.previous.maxAge) {
        stroke(this.displayColor, alpha);
        strokeWeight(3);
        line(this.position.x, this.position.y, this.previous.position.x, this.previous.position.y);
        strokeWeight(1);
        stroke(bgColor);
      } 
    }
  }
}

// store deltas for triangle easily
class TriangleDeltas {
  PVector delta1, delta2, delta3;
  
  TriangleDeltas(float dx1, float dy1, float dx2, float dy2, float dx3, float dy3) {
    this.delta1 = new PVector(dx1, dy1);
    this.delta2 = new PVector(dx2, dy2);
    this.delta3 = new PVector(dx3, dy3);
    
  }
  
}