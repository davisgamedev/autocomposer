class Time {
  boolean isRest = false;

  int measures = 0; //total number of measures since the start of song
  int sectionSize = 4; //number of measures in a section

  float currentBeat = 0f; //the current beat in the current measure
  int currentMeasure = 0; //current measure in section
  int quarterBeat = 0; //current rounded quarter beat

  int BPM = 120; //beats per minute
  long lastTime = System.currentTimeMillis();
  float ellapsedTime;

  void updateTime() {
    long currentTime = System.currentTimeMillis() - lastTime;
    ellapsedTime = currentTime/1000;
    currentBeat += (ellapsedTime/(BPM/60));
    if (currentBeat >= 5) {
      currentBeat = 0;
      measures++;
      currentMeasure = measures % 4;
    }

    quarterBeat = floor(currentBeat);
  }

  //is the beat syncopated according to subDivision
  //subDivision: 1/4 = quarter notes
  boolean isSyncopated(float subDivision) {
    return  currentBeat % (subDivision * 4) < 1;
  }
}