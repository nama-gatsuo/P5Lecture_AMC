float w[] = {
  0.33, 0.05
};

// params of affin
float pa[][] = {
  { 0.59, 0.59, -0.17, 0.31, -1., -0.81 },
  { 0.84, 0.8, -0.63, 0.67, -0.45, 0.54 },
  { 0.51, -0.52, -0.43, 0.93, 0.2, 0.99 }
};

// params of variation
float pv[][] = {
  { 0.28, 0.58, 0.71, 0, 0 },
  { 0.05, -0.07, 0.43, 0, 0 },
  { 0.99, 0, 0, 0, 0 }
};

Boolean vFlags[] = { true, false, false, false, false };

void setup() {
  size(1024, 1024);
  blendMode(ADD);
  colorMode(HSB, 360, 100, 100, 100);
  pattern(floor(random(1, 4)));
}

void draw() {}

void pattern(int gNum) {
  background(2, 9, 12);
  
  float gw = width / gNum;
  float gh = height / gNum;
  
  for (int xi = 0; xi < gNum; xi++) {
    for (int yi = 0; yi < gNum; yi++) {
      pushMatrix();
      translate(gw * (float(xi) + 0.5), gh * (float(yi) + 0.5));
      drawShape(gw);
      popMatrix();
    }
  }
}

void drawShape(float size) {
  
  randamize();
  
  stroke(random(180, 240), 80, 80, 50);
  
  float coin = 0.;
  PVector p = new PVector(0, 0);
  
  for (int i = 0; i < 200000; i++) {  
    coin = random(1.0);
    if (coin < w[0]) p = variation(affin(p, pa[0]), pv[0]);
    else if (coin < w[0] + w[1]) p = variation(affin(p, pa[1]), pv[1]);
    else p = variation(affin(p, pa[2]), pv[2]);
    point(p.x * size, p.y * size);
  }
}

PVector affin(PVector p, float[] pas) {
  float x = pas[0]* p.x + pas[1]* p.y + pas[2];
  float y = pas[3]* p.x + pas[4]* p.y + pas[5];
  p.x = x;
  p.y = y;
  return p;
}

PVector variation(PVector p, float[] pvs) {
  PVector cp = p.copy();
  PVector p_ = new PVector(0, 0);
  if (pvs[0] > 0) p_.add(v1(cp.copy()).mult(pvs[0]));
  if (pvs[1] > 0) p_.add(v2(cp.copy()).mult(pvs[1]));
  if (pvs[2] > 0) p_.add(v3(cp.copy()).mult(pvs[2]));
  if (pvs[3] > 0) p_.add(v4(cp.copy()).mult(pvs[3]));
  if (pvs[4] > 0) p_.add(v5(cp.copy()).mult(pvs[4]));
  return p_;
}

// Linear
PVector v1(PVector p) {
  return p;
}

// Spherical
PVector v2(PVector p) {
  float r2 = p.x * p.x + p.y * p.y;
  p.div(r2);
  return p;
}

// Fisheye
PVector v3(PVector p) {
  float r2 = p.x * p.x + p.y * p.y;
  float r = pow(r2, 0.5);
  p.mult(2.0 / (r + 1.));
  return p;
}

// Tangent
PVector v4(PVector p) {
  p = new PVector(sin(p.x)/cos(p.y), tan(p.y));
  return p;
}

// Bubble
PVector v5(PVector p) {
  float r2 = p.x * p.x + p.y * p.y;
  p.mult(4.0 / r2 + 4.0);
  return p;
}

void randamize() {
  w[0] = random(1.);
  w[1] = random(1. - w[0]);
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 6; j++) {     
      pa[i][j] = random(2.) - 1.;
    }
  }
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 5; j++) {
      if (j == 0) {
        pv[i][j] = random(0.6, .9);
      } else {
        pv[i][j] = random(-1., 0.4);
      }
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    pattern(floor(random(1, 4)));
  }
  if (key == 's') {
    saveFrame("capture-######.png");
  }
}
