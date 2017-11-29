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
  }
  
  // update note age and features
  void update() {
    if (this.dying) {
      this.age++;
      if (risingEffect) {
        this.position.y -= 3;
      }
    }
  }
  
  // display node on canvas
  void display() {
    // fade graphic as dying
    float alpha = scaleVal((float) this.age, 0, this.maxAge, 255, 0);
    fill(this.displayColor, alpha); 
    ellipse(this.position.x, this.position.y, this.size, this.size);
  }
}