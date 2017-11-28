/*

Velocity determines size of ellipse
Age (how long ago note was played) determines opacity of color
Position currently randomized

Color --> ???? (PITCH)

*/

class Note {
   
  int age, maxAge, size;
  PVector position;
  
  Note(int age_, int maxAge_, int size_, int x_, int y_) {
    this.age = age_;
    this.maxAge = maxAge_;
    this.position = new PVector(x_, y_);
    this.size = size_;
  }
  
  // update note age and features
  void update() {
    this.age++;
  }
  
  // display node on canvas
  void display() {
   ellipse(this.position.x, this.position.y, this.size, this.size);
    
  }
}