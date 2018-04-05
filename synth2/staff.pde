class Staff{
  
  float margin = 25;
  float size = 10;
  
  Staff(){}
  
  void drawStaff(){
  for(int l = 0; l < 4; l++){
   for(int i = 0; i < 5; i++){
      
      float ty = getY(l, i);
      line(width/2, ty, width, ty);
     }
    }
    pushMatrix();
      translate(width/2, 0);
      placeChords();
    popMatrix();
  }
  
  float getY(int row, int line){
    //temp_y = y_total + marg_total + curr_line + marg_offset
     return  row*size*5 + row*margin + line*size + margin/2;
  }
  
  void drawNote(int row, int position, boolean isSharp, float offX){
    //invert position
    position = position - ((position - 4)*2); 
    int line = position/2;
    float l0 = getY(row, 0);
    
    if(line < 0){
      for(int i = -1; i >= line; i--){
          line(offX-size/1.5, l0 + i*size, offX + size/1.5, l0 + i*size);
      }
    }
    else if(line >= 5){
      float l4 = getY(row, 4);
      for(int i = 5; i <= line; i++){
          line(offX-size/2, l4 + i*size, offX + size/2, l4 + i*size);
      }
    }
    ellipse(offX, l0 + (position*size/2), size * 1.2, size * .95);
    if(isSharp){      
       fill(255, 200, 0);
       text("#", offX + size, l0 + (position*size*2));
       noFill();
    }
  }
  
  void placeChords(){
    noFill();
    stroke(255, 200, 0);
    int row = 0;
    for(ArrayList<String> chord : chords){
      for(String pitch : chord){
        //C2, C#2
        int pHeight = pitch.charAt(0) - 'E' + Character.getNumericValue(pitch.charAt(pitch.length()-1)-3)*8;
        boolean isSharp = pitch.length() > 2;
        drawNote(row, pHeight, isSharp, size * 1.5);
      }
      row++;
    }
  }
}