//Davis Smith, modified from class materials

// Magic words to import minim library
import ddf.minim.*;
import ddf.minim.ugens.*;
import java.util.Arrays;

// Need an object for the Minim system
Minim minim;

// Need an object for the output to the speakers
AudioOutput out;

//TODO melody generator from chords
//TODO look into generating chords not picking random
//TODO make it less jazzy

// Need a unit generator for the oscillator
ArrayList<Voice> chordWaves;
Voice wave;

Staff staff = new Staff();
Time Time = new Time();

String currentPitch = "--";

enum GEN_MODES{
   RANDOMJAZZ,
   CHROMATIC,
   SEMICHROMATIC,
   DIATONIC
}
GEN_MODES currentGenMode = GEN_MODES.DIATONIC;

String[] modeNames = new String[]{
  "Ionian",
  "Dorian",
  "Phrygian",
  "Lydian",
  "Mixolydian",
  "Aeolian",
  "Locrian"
};
int[][] modes = new int[][]{
  {2, 2, 1, 2, 2, 2, 1}, //Ionian
  {2, 1, 2, 2, 2, 1, 2}, //Dorian
  {1, 2, 2, 2, 1, 2, 2}, //Phrygian
  {2, 2, 2, 1, 2, 2, 1}, //Lydian
  {2, 2, 1, 2, 2, 1, 2}, //Mixolydian
  {2, 1, 2, 2, 1, 2, 2}, //Aeolian
  {1, 2, 2, 1, 2, 2, 2}  //Locrian
};

String[] pitches = new String[]{
     "A",
     "A#",
     "B",
     "C",
     "C#",
     "D",
     "D#",
     "E",
     "F",
     "F#",
     "G",
     "G#"
};

ArrayList<String> chromats;

ArrayList<String> notes;
ArrayList<ArrayList<String>> chords;
int mode;
int scale;

void setup()
{
  frameRate(60);
  
  // width/2 is the number of samples in the sample table
  size(1024, 300);
  
  // Magic words to create an object for the audio system
  minim = new Minim(this);
  
  // Use getLineOut method Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // Create a sine wave Oscil object, set to 440 Hz, at 0.25 amplitude
  wave = new Voice(out, Waves.TRIANGLE);
  
  chordWaves = new ArrayList();
  for(int i = 0; i < 4; i++){
    chordWaves.add(new Voice(out, Waves.SINE, 0.1));
  }
  
  generate();
}


// Use draw to display the waveform in green and the output in white
void draw()
{
  update();
  background(0);
  

  // Draw the waveform shape we are using in the oscillator
  stroke( 102, 255, 140 );  // Green
  strokeWeight(4);
  for( int i = 0; i < width/2-1; ++i )
  {
    point(i,
      200/2 - (200*0.49)*wave.wave.getWaveform().value((float)i/width/2));
  }
  
  
  // Draw the actual waveform in real time
  stroke(140, 102, 255);              // purple
  strokeWeight(1);  
  // Draw the waveform of the output in stereo
  for(int i = 0; i < out.bufferSize()/2 - 1; i += 1)
  {
    line(i,  50-out.left.get(i)*50,  i+1,  50 - out.left.get(i+1)*50);
    line(i, 150-out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50);
  }
  
  //volume
  text("enter : regenerate", 10, 218);
  text("shift : change gen mode", 10, 233);
  fill(255, 200, 0);
  text("current gen mode: " + currentGenMode, 10, 248);

  //waveforms
  // \t doesn't work for some reason in processing
  fill(0, 255, 0);
  text("1 : sine       2 : triangle     3 : saw", 10, 273);
  text("4 : square   5 : quarter     6 : phasor", 10, 288);

  fill(200, 0, 255);
  text("Scale: " + pitches[scale] + ", Mode: " + modeNames[mode], width/2/2, 218);
  fill(0, 100, 255);
  for(int i = 7; i < 15; i++){
    int gap = (i-7) * 30;
    text(notes.get(i), width/2/2 + gap, 233);
  }
  
  fill(255, 100, 0);
  text("Chord: ", width/2/2, 248);
  for(int i = 0; i < chords.get(Time.currentMeasure).size(); i++){
      String n = chords.get(Time.currentMeasure).get(i);
      text(n, 50 + width/2/2 + (30 * i), 248); 
  }
  
  fill(0, 255, 255);
  text(("Current note: " + currentPitch), width/2/2, 263);
  
  stroke(255);
  line(width/2, 0, width/2, height);
  
  staff.drawStaff();
}

void update(){
   
    Time.updateTime();
    
    for(int i = 0; i < 4; i++){
      chordWaves.get(i).play(chords.get(Time.currentMeasure).get(i));
    }
    
    wave.update(Time.deltaBeat);
    
    if( !wave.canPlay() ) return;
    //two beats per 60 frames (120 bpm), one measure = 120 frames
    
    float newBeat = map(
      random(0, 1),
      0,
      1,
      1/16,
      1
    );
    if( random(0, 1) > 0.4){
      wave.rest(newBeat, 0.001);
      return;
    }
    
    wave.targetAmp(0.25, 0.01);
    
    //currentPitch = chords.get(measure).get(;
    int currentChordNote = notes.indexOf(chords.get(Time.currentMeasure).get(floor(random(0, 4))));
    currentChordNote += map(randomGaussian(), -5, 5, -3, 3);
    if(currentChordNote < 0) currentChordNote = 0;
    currentChordNote %= notes.size();
    currentPitch = notes.get(currentChordNote);
    wave.play(currentPitch, newBeat);
}

void incrementEnum(){
  currentGenMode = GEN_MODES.values()[(currentGenMode.ordinal()+1)%GEN_MODES.values().length];
}

void generate(){
  notes = new ArrayList();
  
  mode = floor(random(0, modes.length));
  scale = floor(random(0, pitches.length));
  
  for(int o = 2; o < 5; o++){
    int n = scale;
    for(int m = 0; m < modes[mode].length; m++){
      notes.add(
        pitches[n] + o
      );
      n += modes[mode][m];
      n %= pitches.length; //check if last interval is correct, might be missing one
    }
  }
  
  chromats = new ArrayList();
  for(int o = 2; o < 5; o++){
    for(int p = 0; p < pitches.length; p++){
      chromats.add(pitches[p] + o);
    }
  }
  
  chords = new ArrayList();
  switch(currentGenMode){
    case RANDOMJAZZ:
      doRandomChords();
      break;
     case DIATONIC:
      doDiatonicChordMod();
      break;
     case CHROMATIC:
      doChromaticChordMod();
      break;
     case SEMICHROMATIC:
       doSemiChromaticChordMod();
       break;
  }
}

// called every time user presses a key.  Only care about '1' - '5'
void keyPressed()
{ 
    switch(keyCode){
      ////////set amp/////////
      case(ENTER):
        generate();
      break;
      case(SHIFT):
        incrementEnum();
        break;
      default: break;
    }
  }
  
void stop()         // Override the default stop() method to clean up audio
{
  out.close();      // Close up all the sounds
  minim.stop();     // Close up minim itself
  super.stop();     // Close up rest of program
}