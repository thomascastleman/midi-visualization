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
  color displayColor = color(0, 200, 200);
  
  Note(int channel_, int pitch_, int velocity_, int x_, int y_) {
    this.channel = channel_;
    this.pitch = pitch_;
    this.velocity = velocity_;
    
    this.age = 0;  // age starts at 0
    this.position = new PVector(x_, y_);
    this.size = velocity_;  // size is velocity
    
    // scale velocity from 0-100 to 5-55 (arbitrarily)
    this.maxAge = (int) ((float) velocity_ / 100.0f) * 100 + 20;
  }
  
  // update note age and features
  void update() {
    if (this.dying) {
      this.age++;
    }
  }
  
  // display node on canvas
  void display() {
    // fade graphic as dying
    float alpha = scaleVal(this.age, 0, this.maxAge, 255, 0);
    fill(this.displayColor, alpha); 
    ellipse(this.position.x, this.position.y, this.size, this.size);
  }
}