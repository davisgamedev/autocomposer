class Voice{
  
  Oscil wave;
  float currentAmp = 0f;
  
  float duration = 0;
  float left
  
  float targetAmp;
  float velocityAmp;
  public boolean needsUpdate = false;
  
  public Voice(AudioOutput out, Waveform form){
    wave = new Oscil( 440, currentAmp, form ); 
    wave.patch(out);
  }
  
  public Voice(AudioOutput out, Waveform form, float amp){
    wave = new Oscil( 440, amp, form ); 
    wave.patch(out);
    currentAmp = amp;
  }
  
  public void update(){
    if(needsUpdate){
      if(velocityAmp > currentAmp && currentAmp + velocityAmp > targetAmp)
        incVolume(velocityAmp);
      else if(velocityAmp < currentAmp && currentAmp - velocityAmp > targetAmp)
        decVolume(velocityAmp);
      else needsUpdate = false;
    }
  }
  
  public void setVolume(float amp){
     wave.setAmplitude(amp); 
     currentAmp = amp;
  }
  
  public void decVolume(float amount){
     if(currentAmp - amount > 0)
       currentAmp -= amount;
     else
       currentAmp = 0;
     wave.setAmplitude(currentAmp);
  }
  
  public void incVolume(float amount){
    if(currentAmp + amount < 1)
       currentAmp += amount;
     else
       currentAmp = 1;
     wave.setAmplitude(currentAmp);
  }
  
  public void targetAmp(float amp, float velocity){
     needsUpdate = true;
     targetAmp = amp;
     velocityAmp = velocity;
  }
  
  public void play(String pitch){
      wave.setFrequency(Frequency.ofPitch(pitch));
  }
  
  public void play(String pitch, float duration){
    
  }
  
  public void rest(float duration){
    
  }
  
  public boolean canPlay(){
    
  }
}