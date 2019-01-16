// declaration & implementation of class
class SinePattern {
  
  ArrayList<Float> r, f;
  
  PVector pos;
  PVector p0, p1, p2, p3;  
  float tSpace, tPitch;
  float shrink;
  
  color hsb;
  
  // constructor
  SinePattern(int xi, int yi, float gSize, color _hsb) {
    
    r = new ArrayList<Float>(4);  
    f = new ArrayList<Float>(4);
    
    for (int ri = 0; ri < 4; ri++) {
      r.add(random(gSize / 2. * 0.3, gSize / 2. * 0.98));
      f.add(random(1, 4));
    }
    
    pos = new PVector(gSize * (float(xi) + 0.5), gSize * (float(yi) + 0.5));
  
    p0 = new PVector();
    p1 = new PVector();
    p2 = new PVector();
    p3 = new PVector();
  
    int dnum = floor(random(30, 100));
    tSpace = TWO_PI / float(dnum);
    tPitch = tSpace * random(0.4, 0.9);
    hsb = _hsb;
    shrink = random(0.1, 0.8);
    
  }
  
  
  void draw(float t) {
    
    pushMatrix();
    translate(pos.x, pos.y);
  
    int i = 0;
    
    for (float theta = 0; theta < TWO_PI; theta += tSpace) {
      
      float m = 1. - shrink * (theta / TWO_PI);
      
      p0.x = r.get(0) * cos(f.get(0) * theta + t) * m;
      p0.y = r.get(1) * sin(f.get(1) * theta - t) * m;
      p1.x = r.get(2) * cos(f.get(2) * theta - t) * m;
      p1.y = r.get(3) * sin(f.get(3) * theta + t) * m;
      
      float _t = theta + tPitch;
      
      p2.x = r.get(0) * cos(f.get(0) * _t + t) * m;
      p2.y = r.get(1) * sin(f.get(1) * _t - t) * m;
      p3.x = r.get(2) * cos(f.get(2) * _t - t) * m;
      p3.y = r.get(3) * sin(f.get(3) * _t + t) * m;
      
      if (i % 6 == 5) {
        int h = ((int)hue(hsb) + 180) % 360;
        fill(h, saturation(hsb), brightness(hsb));
      } else {
        int b = (int)brightness(hsb);             
        b -= 5 * (i % 6);
        fill(hue(hsb), saturation(hsb), b);
      }
      
      beginShape();
      vertex(p0.x, p0.y);
      vertex(p1.x, p1.y);
      vertex(p3.x, p3.y);
      vertex(p2.x, p2.y);
      endShape(CLOSE);
    
      i++;
    }   
    popMatrix();
  }
}
