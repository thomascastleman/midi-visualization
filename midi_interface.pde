import themidibus.*; //Import the library
import java.util.*;

MidiBus myBus; // The MidiBus

//// at school keyboard
//int minPitch = 36;
//int maxPitch = 96;

// my ypg-625:
int minPitch = 21;
int maxPitch = 108;

ArrayList<Note> notes = new ArrayList<Note>();  // all note objects
ArrayList<Note> notesToAdd = new ArrayList<Note>(); // all notes that currently need to be added to notes

ArrayList<Tuple> release = new ArrayList<Tuple>();  // note values currently being released
ArrayList<Tuple> toRelease = new ArrayList<Tuple>(); // note values (channel, pitch...) to be released

void setup() {
  size(700, 700);
  background(0);
  fill(0, 100, 200);

  MidiBus.list(); // List all available Midi devices
  myBus = new MidiBus(this, 0, 3); // init MidiBus
  
  
  //noLoop();
  
  //fill(255, 0, 0);
  //ellipse(width / 2 + 45, height / 2 + 45, 100, 100);
  
  //fill(0, 255, 0, 100);
  //ellipse(width / 2, height / 2, 100, 100);
}

// scale value from one range to another
float scaleVal(int value, int oldMin, int oldMax, int newMin, int newMax) {
  return (((float) (value - oldMin)) / (oldMax - oldMin)) * (newMax - newMin) + newMin;
}

void draw() {
  background(0);
  
  // add all waiting releases
  release.addAll(toRelease);
  toRelease.clear();
  
  // release all
  ListIterator<Tuple> releaseIter = release.listIterator();
  while (releaseIter.hasNext()) {
    Tuple t = releaseIter.next();
    for (Note n : notes) {
      if (n.channel == t.channel && n.pitch == t.pitch) {
        println("Successfully released note");
        n.dying = true;
      }
    }
  }
  release.clear();
  
  // add all waiting notes
  notes.addAll(notesToAdd);
  notesToAdd.clear();
  
  // iterate through all notes currently being displayed
  ListIterator<Note> iter = notes.listIterator();
  while (iter.hasNext()) {
    Note n = iter.next();
    // update age and display with proper coloring
    n.update();
    n.display();
    // remove if note dead
    if (n.age == n.maxAge) {
      iter.remove();
    }
  }
  
}

float scalePitchToColor(int pitch) {
  return 0.0;
}

void noteOn(int channel_, int pitch_, int velocity_) {
  // debug
  println("NOTE PLAYED WITH PITCH " + pitch_ + " AND VELOCITY " + velocity_);
  
  // construct new note @ random position and add to waiting queue of notes to be added to global list
  Note n = new Note(channel_, pitch_, velocity_, (int) random(width), (int) random(height));
  notesToAdd.add(n);
}

void noteOff(int channel, int pitch, int velocity) { 
  // debug
  println("NOTE FINISHED PLAYING: " + channel + ", " + pitch + ", " + velocity);
  toRelease.add(new Tuple(channel, pitch));
}

// let note fade
void releaseNote(int channel, int pitch) {
  //for (Note n : notes) {
  //  if (n.channel == channel && n.pitch == pitch) {
  //    println("Successfully released note");
  //    n.dying = true;
  //  }
  //}
  
  //ListIterator<Note> iter = notes.listIterator();
  //while (iter.hasNext()) {
  //  Note n = iter.next();
  //  if (n.channel == channel && n.pitch == pitch) {
  //    println("Successfully released note");
  //    n.dying = true;
  //  }
  //}
  
}

void controllerChange(int channel, int number, int value) {
  println();
  println("Controller Change:");
  //println("--------");
  //println("Channel:"+channel);
  //println("Number:"+number);
  //println("Value:"+value);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

// store channel, pitch values easily
class Tuple {
  int channel, pitch;
  
  Tuple(int c, int p) {
    this.channel = c;
    this.pitch = p;
  }
}