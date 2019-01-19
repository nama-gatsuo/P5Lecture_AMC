void setup() {
  size(1024, 1024);
  blendMode(ADD);
  stroke(32);
  
  pattern(floor(random(1, 6)));
}

void pattern(int gNum) {
  background(2, 9, 12);
  
  float gw = width / gNum;
  float gh = height / gNum;
  
  ArrayList<Float> r = new ArrayList<Float>(4);
  ArrayList<Float> f = new ArrayList<Float>(4);
  
  for (int xi = 0; xi < gNum; xi++) {
    for (int yi = 0; yi < gNum; yi++) {
      pushMatrix();
      translate(gw * (float(xi) + 0.5), gh * (float(yi) + 0.5));
      
      r.clear();
      f.clear();
      for (int ri = 0; ri < 4; ri++) {
        r.add(random(gw / 2. * 0.1, gw / 2. * 0.98));
        f.add(float(floor(random(1, 12))));
      }
      
      drawShape(r, f);
      popMatrix();
    }
  }
}

void drawShape(ArrayList<Float> r, ArrayList<Float> f) {
  
  PVector p0 = new PVector(), p1 = new PVector();
  
  for (float t = 0; t < TWO_PI; t += 0.01) {
    p0.x = r.get(0) * cos(f.get(0) * t + HALF_PI);
    p0.y = r.get(1) * sin(f.get(1) * t - HALF_PI);
    p1.x = r.get(2) * cos(f.get(2) * t + HALF_PI);
    p1.y = r.get(3) * sin(f.get(3) * t - HALF_PI);      
    line(p0.x, p0.y, p1.x, p1.y);
  }
}

void draw(){}

void keyPressed() {
  if (key == 'r') {
    pattern(floor(random(1, 6)));
  }
  if (key == 's') {
    saveFrame("capture-######.png");
  }
}
