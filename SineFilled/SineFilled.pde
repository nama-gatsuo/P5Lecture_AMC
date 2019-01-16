ArrayList<SinePattern> pats;

void setup() {
  size(1024, 1024);
  stroke(0);
  strokeWeight(0.5);
  frameRate(30);
  colorMode(HSB, 360, 100, 100);
  pats = new ArrayList<SinePattern>();
  
  createPattern(3);
}

void draw(){
  background(198, 2, 100);
  for (SinePattern sp : pats) {
    sp.draw(millis() / 1000.);
  }
}

void keyPressed() {
  if (key == 'r') {
    createPattern(floor(random(1, 4)));
  }
  if (key == 's') {
    saveFrame("capture-######.png");
  }
}

void createPattern(int gNum) {
  
  pats.clear();
  
  float gSize = width / gNum;
  
  int keyHue = floor(random(360));
  int sat = floor(random(20, 100));
  int bri = floor(random(50, 100));
  color c = color(keyHue, sat, bri);
  
  for (int xi = 0; xi < gNum; xi++) {
    for (int yi = 0; yi < gNum; yi++) {
      pats.add(new SinePattern(xi, yi, gSize, c));
    }
  }
  
}
