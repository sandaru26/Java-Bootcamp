void setup(){
  size(800,600);
  background(random(255));
}

void draw(){
  fill(10,150,20);
  
  triangle(mouseX,mouseY,mouseX+30,mouseY+60,mouseX+60,mouseY);
  
}
  
  
