PVector p;

float weight[] = {
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
  
  strokeWeight(1.);
  exec();
}

void draw() {}

void exec() {
  background(0);
  pattern(floor(random(1, 4)));
}

void pattern(int gNum) {
  background(2, 9, 12);
  
  float gw = width / gNum;
  float gh = height / gNum;
  
  for (int xi = 0; xi < gNum; xi++) {
    for (int yi = 0; yi < gNum; yi++) {
      pushMatrix();
      translate(gw * (float(xi) + 0.5), gh * (float(yi) + 0.5));
      drawShape(gw*.1);
      popMatrix();
    }
  }
}

void drawShape(float size) {
  
  randamize();
  p = new PVector();
  
  stroke(random(180, 360), 80, 100, 50);
  
  float coin;
  PVector tp = new PVector();
  
  for (int i = 0; i < 200000; i++) {
    coin = random(1.0);
    if (coin < weight[0]) tp = variation(affin(p, pa[0]), pv[0]);
    else if (coin < weight[0] + weight[1]) tp = variation(affin(p, pa[1]), pv[1]);
    else tp = variation(affin(p, pa[2]), pv[2]);
    
    point(tp.x * size * 2., tp.y * size * 2.);
    p = tp;
  }
}

PVector affin(PVector _p, float[] pas) {
  PVector p_ = new PVector();
  p_.x = pas[0]*_p.x + pas[1]*_p.y + pas[2];
  p_.y = pas[3]*_p.x + pas[4]*_p.y + pas[5];
  return p_;
}

PVector variation(PVector _p, float[] pvs) {
  PVector p_ = v1(_p).mult(pvs[0]);
  if(vFlags[1]) p_.add( v2(_p).mult(pvs[1]) );
  if(vFlags[2]) p_.add( v3(_p).mult(pvs[2]) );
  if(vFlags[3]) p_.add( v4(_p).mult(pvs[3]) );
  if(vFlags[4]) p_.add( v5(_p).mult(pvs[4]) );
  return p_;
}

// Linear
PVector v1(PVector _p) {
  PVector p_ = _p.copy();
  return p_;
}

// Spherical
PVector v2(PVector _p) {
  PVector p_ = _p.copy();
  
  float r2 = _p.x * _p.x + _p.y * _p.y;
  
  p_.x = _p.x / r2;
  p_.y = _p.y / r2;
  
  return p_;
}

// Fisheye
PVector v3(PVector _p) {
  
  PVector p_ = _p.copy();
  float r2 = _p.x * _p.x + _p.y * _p.y;
  float r = pow(r2, 0.5);
  
  p_ = _p.mult(2.0 / (r + 1));
  
  return p_;
}

// Tangent
PVector v4(PVector _p) {
  PVector p_ = new PVector(sin(_p.x)/cos(_p.y), tan(_p.y));
  return p_;
}

// Bubble
PVector v5(PVector _p) {
  PVector p_ = _p.copy();
  float r2 = _p.x * _p.x + _p.y * _p.y;
  
  p_ = _p.mult(4.0 / r2 + 4.0);
  
  return p_;
}

void randamize() {
  
  weight[0] = random(0.5);
  weight[1] = random(0.5);
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 6; j++) {
            
      pa[i][j] = random(2.) - 1.;
      
      
    }
  }
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 5; j++) {
      
      pv[i][j] = random(1.);
    }
  }
  
  for (int i = 1; i < 5; i++) {
    vFlags[i] = random(1.) > .5; 
  }
}

void keyPressed() {
  if (key == 'r') {
    pattern(floor(random(1, 6)));
  }
  if (key == 's') {
    saveFrame("capture-######.png");
  }
}
