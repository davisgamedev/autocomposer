void doRandomChords(){
  for(int i = 0; i < 4; i++){
     chords.add(new ArrayList());
     while(chords.get(i).size() < 4){
       int index = floor(random(8, notes.size()));
       String note = notes.get(index);
       if(!chords.get(i).contains(note)){
         chords.get(i).add(note);
       }
     }
  }
}

//these values should be different between diatonic and chromatic lists
void doDiatonicChordMod(){
  String[] baseChord = new String[]{
      notes.get(7),
      notes.get(9),
      notes.get(11),
      notes.get(14)
  };
  for(int i = 0; i < 4; i++){
    for(int j = 0; j < random(0, 6); j++){
      int toMod = floor(random(0, 4));
      int newNote = floor(randomGaussian()) + notes.indexOf(baseChord[toMod]);
      if(newNote < 0 || newNote > notes.size()) continue;
      if(!Arrays.asList(baseChord).contains(chromats.get(newNote))){
          baseChord[toMod] = notes.get(newNote);
        }
    }
    chords.add(new ArrayList(Arrays.asList(baseChord)));
  }
}

void doChromaticChordMod(){
  String[] baseChord = new String[]{
      notes.get(7),
      notes.get(9),
      notes.get(11),
      notes.get(14)
  };
  for(int i = 0; i < 4; i++){
    for(int j = 0; j < random(0, 6); j++){
      int toMod = floor(random(0, 4));
      int newNote = floor(randomGaussian()) + chromats.indexOf(baseChord[toMod]);
      if(newNote < 0 || newNote > chromats.size()) continue;
      if(!Arrays.asList(baseChord).contains(chromats.get(newNote))){
            baseChord[toMod] = chromats.get(newNote);
          }
    }
    chords.add(new ArrayList(Arrays.asList(baseChord)));
  }
}

void doSemiChromaticChordMod(){
  String[] baseChord = new String[]{
      notes.get(7),
      notes.get(9),
      notes.get(11),
      notes.get(14)
  };
  for(int i = 0; i < 4; i++){
    for(int j = 0; j < random(0, 6); j++){
      if(random(1) > 0.8){
          int toMod = floor(random(0, 4));
          int newNote = floor(randomGaussian()) + chromats.indexOf(baseChord[toMod]);
          if(newNote < 0 || newNote > chromats.size()) continue;
          if(!Arrays.asList(baseChord).contains(chromats.get(newNote))){
            baseChord[toMod] = chromats.get(newNote);
          }
      }
      else{
        int toMod = floor(random(0, 4));
        int newNote = floor(randomGaussian()) + notes.indexOf(baseChord[toMod]);
        if(newNote < 0 || newNote > notes.size()) continue;
        if(!Arrays.asList(baseChord).contains(notes.get(newNote))){
            baseChord[toMod] = notes.get(newNote);
          }
      }
    }
    chords.add(new ArrayList(Arrays.asList(baseChord)));
  }
}