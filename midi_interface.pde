import themidibus.*; //Import the library
import java.util.*;

MidiBus myBus; // The MidiBus

int channel;
int pitch;
int velocity;

int minPitch = 36;
int maxPitch = 96;

int maximumAge = 20;  // num frames each note gets
ArrayList<Note> notes = new ArrayList<Note>();  // all note objects
ArrayList<Note> notesToAdd = new ArrayList<Note>(); // all notes that currently need to be added to notes


void setup() {
  size(700, 700);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 3); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  
  
  fill(0, 100, 200);
  
  
}

void draw() {
  background(0);
  
  ListIterator<Note> iter = notes.listIterator();
  
  while (iter.hasNext()) {
    Note n = iter.next();
    
    if (n.age == n.maxAge) {
      iter.remove();
    }
  }
  
  
  ArrayList<Note> extra = new ArrayList<Note>();
  
  notes.addAll(notesToAdd);
  notesToAdd.clear();
  
  iter = notes.listIterator();
  // update and display all notes
  while (iter.hasNext()) {
    Note n = iter.next();
    n.update();
    n.display();
    
    if (notesToAdd.size() > 0) {
      for (Note note : notesToAdd) {
        note.display();
        iter.add(note);
        extra.add(note);
      }
      notesToAdd.clear();
    }
  }
  notes.addAll(extra);
  extra.clear();

}

float scalePitchToColor(int pitch) {
  return 0.0;
}

void noteOn(int channel_, int pitch_, int velocity_) {
  //println("NOTE ON");
  //println("Channel:"+channel_);
  //println("Pitch:"+pitch_);
  //println("Velocity:"+velocity_);
  
  println("NOTE PLAYED WITH PITCH " + pitch_ + " AND VELOCITY " + velocity_);
  
  channel = channel_;
  pitch = pitch_;
  velocity = velocity_;
  
  // construct new note and add to currently displayed notes
  Note n = new Note(0, maximumAge, velocity, (int) random(width), (int) random(height));
  notesToAdd.add(n);
  //notes.add(n);
}

void noteOff(int channel, int pitch, int velocity) { 
  println("NOTE FINISHED PLAYING");
  channel = 0;
  pitch = 0;
  velocity = 0;
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}