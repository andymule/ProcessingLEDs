import controlP5.*;
import java.lang.Math.*;

final int pixelcount = 600; // doesn't control everything yet, be careful
int PIXELSIZE = 10; // doesn't control everything yet, be careful

PShape[] allLeds = new PShape[pixelcount]; 
ControlP5 cp5;

private class Signal {
  float hz = 1.0;
  float amp = 1.0;
  float floor = 0;
  float phase = 0;
  float sampleSpacing = 1;
  String name = "color";
  public Signal(String nameIn) { this.name = nameIn; }
  public float At(int point, float timeNow)
  {
    float lfoOrigin = ((timeNow + phase + sampleSpacing * point % 1000.0) * TWO_PI) / 1000.0;  // a sine wave a 1hz, considering phase and sampling
    float value = sin(lfoOrigin * hz);   // speed up or slow down lfo by desired HZ input\\
    value *= amp; // scale based on amp power
    value += floor; // adjust starting point
    return value;
  }
}

Signal Red = new Signal("red");
Signal Green = new Signal("green");
Signal Blue = new Signal("blue");

void setup() {
  size(300, 600);
  background(5, 0, 5);
  for (int x = 0; x < allLeds.length; x++) { // make all pixels
    allLeds[x] = createShape(RECT,(x % 30) * PIXELSIZE, floor(x / 30) * PIXELSIZE, 8, 8);
    allLeds[x].setFill(color(0,10,10));
  }
  setUI();
} 

void draw() {
  float timeNow = millis();
  for (int x = 0; x < allLeds.length; x++) {
    float redHere = Red.At(x, timeNow) * 255.;
    float greenHere = Green.At(x, timeNow) * 255.;
    float blueHere = Blue.At(x, timeNow) * 255.;
    allLeds[x].setFill(color(redHere,greenHere,blueHere));
    shape(allLeds[x]);
  }
}

void setUI() {
  cp5  = new ControlP5(this);
  cp5.addSlider("red hz").plugTo(Red, "hz").setPosition(10, 300).setRange(0., 100.).setValue(.5);
  cp5.addSlider("red amp").plugTo(Red, "amp").setPosition(10, 315).setRange(0., 1.).setValue(1.0);
  cp5.addSlider("red floor").plugTo(Red, "floor").setPosition(10, 330).setRange( - 1., 1.).setValue(0.0);
  cp5.addSlider("red phase").plugTo(Red, "phase").setPosition(10, 345).setRange( - 360., 360.).setValue(0.0);
  cp5.addSlider("red sampleSpacing").plugTo(Red, "sampleSpacing").setPosition(10, 360).setRange(1., 1000.);
  cp5.addSlider("green hz").plugTo(Green, "hz").setPosition(10, 400).setRange(0., 100.).setValue(.5);
  cp5.addSlider("green amp").plugTo(Green, "amp").setPosition(10, 415).setRange(0., 1.).setValue(1.0);
  cp5.addSlider("green floor").plugTo(Green, "floor").setPosition(10, 430).setRange( - 1., 1.).setValue(0.0);
  cp5.addSlider("green phase").plugTo(Green, "phase").setPosition(10, 445).setRange( - 360., 360.).setValue(-240.0);
  cp5.addSlider("green sampleSpacing").plugTo(Green, "sampleSpacing").setPosition(10, 460).setRange(1., 1000.);
  cp5.addSlider("blue hz").plugTo(Blue, "hz").setPosition(10, 500).setRange(0., 100.).setValue(.5);
  cp5.addSlider("blue amp").plugTo(Blue, "amp").setPosition(10, 515).setRange(0., 1.).setValue(1.0);
  cp5.addSlider("blue floor").plugTo(Blue, "floor").setPosition(10, 530).setRange( - 1., 1.).setValue(0.0);
  cp5.addSlider("blue phase").plugTo(Blue, "phase").setPosition(10, 545).setRange( - 360., 360.).setValue(240.0);
  cp5.addSlider("blue sampleSpacing").plugTo(Blue, "sampleSpacing").setPosition(10, 560).setRange(1., 1000.);
}
