class Voice{
  
  Oscil wave;
  float currentAmp = 0f;
  
  float duration;
  float ellapsedDuration = 0f;
  
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
      if(targetAmp >= currentAmp && currentAmp + velocityAmp <= targetAmp)
        incVolume(velocityAmp);
      else if(targetAmp <= currentAmp && currentAmp - velocityAmp >= targetAmp)
        decVolume(velocityAmp);
      else needsUpdate = false;
    }
  }
  
  public void update(float deltaBeat){
    update();
    if(duration == 0) return;
    ellapsedDuration += deltaBeat;
    if(ellapsedDuration >= duration){
      duration = 0;
    }
  }
  
  public void setVolume(float amp){
     wave.setAmplitude(amp); 
     currentAmp = amp;
     needsUpdate = false;
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
  
  public void play(String pitch, float length){
    play(pitch);
    ellapsedDuration = 0;
    duration = length;
  }
  
  public void rest(float length, float decVelocity){
    ellapsedDuration = 0;
    duration = length;
    targetAmp(0, decVelocity);
  }
  
  public boolean canPlay(){
    return duration == 0;
  }
}