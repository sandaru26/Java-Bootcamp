void setup(){
  size(600,500);
 // noStroke();
}

void draw(){
 // background(5,180,0);
  
  if(mouseX>width/2 && mousePressed){
    fill(#FFF300);
  }
  else{
    fill(255);
  }
  ellipse(width/2,height/2,300,300);
  
}
