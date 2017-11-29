import themidibus.*; //Import the library
import java.util.*;

MidiBus bus; // The MidiBus

//// at school keyboard
//int MINPITCH = 36;
//int MAXPITCH = 96;

// my ypg-625:
int MINPITCH = 21;
int MAXPITCH = 108;

int pitchRange = MAXPITCH - MINPITCH;  // range of pitch values

ArrayList<Note> notes = new ArrayList<Note>();  // all note objects
ArrayList<Note> notesToAdd = new ArrayList<Note>(); // all notes that currently need to be added to notes

ArrayList<Tuple> release = new ArrayList<Tuple>();  // note values currezntly being released
ArrayList<Tuple> toRelease = new ArrayList<Tuple>(); // note values (channel, pitch...) waiting to be released



int minimumFrameLifeSpan = 70;  // minimum # frames each note will take to fade
int colorCycles = 2;  // number of cycles in the rainbow scale used to color notes

// EFFECTS:
boolean randomPlacement = false;  // are notes randomly placed?
boolean risingEffect = false;    // do notes rise after release?



void setup() {
  // size(700, 700);
  fullScreen();
  background(0);
  fill(0, 100, 200);

  MidiBus.list(); // List all available Midi devices
  bus = new MidiBus(this, 0, 3); // init MidiBus
  
  // noLoop();
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
        // println("Successfully released note");
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

void noteOn(int channel_, int pitch_, int velocity_) {
  // debug
  // println("NOTE PLAYED WITH PITCH " + pitch_ + " AND VELOCITY " + velocity_);
  
  // construct new note and add to waiting queue of notes to be added to global list
  Note n;
  if (randomPlacement) {
    // @ random position
    n = new Note(channel_, pitch_, velocity_, (int) random(width), (int) random(height));
  } else {
    // @ pitch scaled to screen dimensions
    n = new Note(channel_, pitch_, velocity_, (int) scaleVal((float) pitch_, MINPITCH, MAXPITCH, 0, width), height / 2);
  }
  notesToAdd.add(n);
}

void noteOff(int channel, int pitch, int velocity) { 
  // debug
  // println("NOTE FINISHED PLAYING: " + channel + ", " + pitch + ", " + velocity);
  toRelease.add(new Tuple(channel, pitch));
}

//void controllerChange(int channel, int number, int value) {
//  //println();
//  //println("Controller Change:");
//  //println("--------");
//  //println("Channel:"+channel);
//  //println("Number:"+number);
//  //println("Value:"+value);
//}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

// scale value from one range to another
float scaleVal(float value, int oldMin, int oldMax, int newMin, int newMax) {
  return (((float) (value - oldMin)) / (oldMax - oldMin)) * (newMax - newMin) + newMin;
}

// scale pitch to a rainbow color value
color scalePitchToColor(int pitch) {
  float freq = colorCycles * (2 * (float) Math.PI) / pitchRange;
  
  // scale between 0 and pitchRange
  int truePitch = pitch - MINPITCH;
  
  // calc rgb values using out of phase waves
  float r = scaleVal((float) Math.cos(truePitch * freq), -1, 1, 0, 255);
  float b = scaleVal((float) Math.cos(truePitch * freq + 2), -1, 1, 0, 255);
  float g = scaleVal((float) Math.cos(truePitch * freq + 4), -1, 1, 0, 255);
  
  return color(r, g, b);
}

// store channel, pitch values easily
class Tuple {
  int channel, pitch;
  
  Tuple(int c, int p) {
    this.channel = c;
    this.pitch = p;
  }
}