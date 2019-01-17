int MAX_LEVEL = 16;

class TRS {
  PVector t, s;
  float r;
  
  TRS(PVector _t, PVector _s, float _r) {
    t = _t;
    s = _s;
    r = _r;
  }
  
  TRS clone() {
    return new TRS(t.copy(), s.copy(), r);
  }
  
  void applyMatrix() {
    translate(t.x, t.y);
    scale(s.x, s.y);
    rotate(r);
  }
  
};

float h, w;
PVector o1, o2, o3, o4;


class Node {
  ArrayList<TRS> trsList;
  int depth;
  
  Node(ArrayList<TRS> _trsList, int _depth) {
    trsList = new ArrayList<TRS>();
    for (TRS _trs : _trsList) {
      trsList.add(_trs.clone());
    }
    depth = _depth;
  }
  
  void add(TRS trs) {
    trsList.add(trs.clone());
  }
  
  void draw() {
    pushMatrix();
    
    for (TRS trs : trsList) {
      trs.applyMatrix();
    }
    
    fill(256 - 256 / MAX_LEVEL * depth, 255);
    
    beginShape();
    vertex(0 + o1.x, 0 + o1.y);
    vertex(w/2 + o2.x, h/2 + o2.y);
    vertex(0 + o3.x, h + o3.y);
    vertex(-w/2 + o4.x, h/2 + o4.y);
    
    endShape(CLOSE);
        
    popMatrix();
  }
  
};



ArrayList<Node> nodes;
int rNum = 3;
PVector t1, t2;
PVector s1, s2;
float r1, r2;

void setup() {
  
  size(1024, 1024);
  
  
  //noFill();
  noStroke();
  
  nodes = new ArrayList<Node>();
  
}

void drawPattern() {
  background(0);
  
  translate(width/2, height/2);
  
  nodes.clear();
  rNum = floor(random(2, 7));
  
  // randomize params
  o1 = new PVector(random(-10, 20), random(-10, 20));
  //o2 = new PVector(random(-10, 20), random(-10, 20));
  //o3 = new PVector(random(-10, 20), random(-10, 20));
  o2 = new PVector(0, 0);
  o3 = new PVector(0, 0);
  o4 = new PVector(random(-10, 20), random(-10, 20));
  
  w = random(20, 80);
  h = random(40, 600);
  
  t1 = new PVector(random(-100, 100), random(-100, 100));
  t2 = new PVector(random(-100, 100), random(-100, 100));
  
  s1 = new PVector(random(0.55, 0.95), random(0.55, 0.95));
  s2 = new PVector(random(0.55, 0.95), random(0.55, 0.95));
  
  r1 = random(-HALF_PI, HALF_PI);
  r2 = random(-HALF_PI/2, HALF_PI/2);
  //r2 = 0;
  fractalLoop(new ArrayList<TRS>(), 0);
  
  for (int i = MAX_LEVEL; i > 0; i--) { 
    for (Node node : nodes) {
      if (node.depth == i - 1) {
        pushMatrix();
        for (int j = 0; j < rNum; j++) {
          rotate(TWO_PI / rNum);
          node.draw();
        }
        popMatrix();
      }
    }
  }
}

void draw() {}

void fractalLoop(ArrayList<TRS> _trsList, int level) {
  
  nodes.add(new Node(_trsList, level));
  
  if (level > MAX_LEVEL) return;
  
  ArrayList<TRS> trsList1 = new ArrayList<TRS>();
  for (TRS _trs : _trsList) {
    trsList1.add(_trs.clone());
  }
  trsList1.add(new TRS(t1, s1, r1));
  fractalLoop(trsList1, level + 1);
  
  ArrayList<TRS> trsList2 = new ArrayList<TRS>();
  for (TRS _trs : _trsList) {
    trsList2.add(_trs.clone());
  }
  trsList2.add(new TRS(t2, s2, r2));
  fractalLoop(trsList2, level + 1);
  
}

void keyPressed() {
  if (key == 'r') {
    drawPattern();
  }
}
