PImage img;

void setup(){
  size(500,500);
  img = loadImage ("fight.jpg");
  background(0);
}

void draw(){
  
  //image(img,0,0);
  color c;
  if (mouseButton == RIGHT) {
    c = color(0);
  }else {
    c = img.get(mouseX,mouseY);
  }
  float speed = dist(pmouseX, pmouseY, mouseX, mouseY);
  float size = map(speed, 0, 50, 5, 40);
  stroke (c);
  strokeWeight(20);
  //fill(c);
  //ellipse(mouseX,mouseY,50,50);
  line(pmouseX, pmouseY, mouseX, mouseY);
}

void keyPressed(){
  if (key == 'c' || key == 'C') {
    background(0);
  }
  if (key == 's' || key == 'C') {
    save("file.png");
  }
}
