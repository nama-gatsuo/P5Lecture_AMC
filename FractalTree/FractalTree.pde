class Branch {
  float l; // lambda
  float o; // omega
  float t; // theta

  Branch(float _l, float _o, float _t) {
    l = _l;
    o = _o;
    t = _t;
  }
}

static final int MAX_LEVEL = 6;
static final int MAX_BRANCH = 4;

void setup() {
  
  size(1920, 1920);
  blendMode(ADD);
  
  pattern(3);
}
void draw(){}

void pattern(int gNum) {
  background(2, 9, 12);
  
  float gw = width / gNum;
  float gh = height / gNum;
  
  for (int xi = 0; xi < gNum; xi++) {
    for (int yi = 0; yi < gNum; yi++) {
      pushMatrix();
      translate(gw * (float(xi) + 0.5), gh * (float(yi) + 0.5));
      drawShape(gw*0.43);
      popMatrix();
    }
  }
}

void drawShape(float size) {
  ArrayList<Branch> branches = new ArrayList<Branch>();
  
  final int bNum = floor(random(2, MAX_BRANCH + 1));
  float l = 1., o = 0.1, t = PI / 3.;
  stroke(128. * pow(1. / bNum, 1.));
  
  for (int i = 0; i < bNum; i++) {
    if (random(1.) < 0.1) {
      t = -t;
    } else {
      l = random(0.2, 1.);
      o = 1.1 - l;
      t = TWO_PI / floor(random(3, 12)) + floor(random(2)) * PI + floor(random(2)) * random(TWO_PI);
    }
    
    branches.add(new Branch(l, o, t));
  }
  
  fractalLoop(new PVector(0, size/2.), new PVector(0, -size/2.), 0, branches);
}

void fractalLoop(PVector z0, PVector z1, int level, ArrayList<Branch> branches) {
  strokeWeight(8. * pow(1. / (level+1), .6));
  line(z0.x, z0.y, z1.x, z1.y);
  if (level == MAX_LEVEL) return;
  for (int i = 0; i < branches.size(); i++) {
    PVector b0 = calcZ0(z0, z1, branches.get(i));
    PVector b1 = calcZ1(z0, z1, branches.get(i));
    fractalLoop(b0, b1, level + 1, branches);
  }
  
}

PVector calcZ0(PVector z0, PVector z1, Branch b) {
  PVector d = PVector.sub(z1, z0);
  PVector v = PVector.add(d.mult(b.o), z0);
  return v;
}

PVector calcZ1(PVector z0, PVector z1, Branch b) {
  PVector d = PVector.sub(z1, z0);
  PVector v = PVector.add(d.rotate(b.t).mult(b.l), calcZ0(z0, z1, b));
  return v;

}

void keyPressed() {
  if (key == 'r') {
    pattern(floor(random(1, 6)));
  }
  if (key == 's') {
    saveFrame("capture-######.png");
  }
}
