void setup(){
  size(400,400);
}

void draw(){
  background(85,125,100);
  if(mouseX<width/2){
    fill(255,0,0);
  }
  else{
    fill(0,255.0);
  }
  rect(mouseX,mouseY,50,30);
}
