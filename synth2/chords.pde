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

void doBaseChordMod(ArrayList<String> fromList){
  String[] baseChord = new String[]{
      notes.get(7),
      notes.get(9),
      notes.get(11),
      notes.get(14)
  };
  for(int i = 0; i < 4; i++){
    for(int j = 0; j < random(0, 6); j++){
      int toMod = floor(random(0, 4));
      int newNote = floor(randomGaussian()) +fromList.indexOf(baseChord[toMod]);
      if(newNote < 0 || newNote > fromList.size()) continue;
      baseChord[toMod] = fromList.get(newNote);
    }
    chords.add(new ArrayList(Arrays.asList(baseChord)));
  }
}