

void setup(){
  size(400,400);
 // target(width/2,height/2);
}

void draw(){
 target(random(20,200),random(20,200));
  
}
void target(int xPos,int yPos){
  fill(0,255,0);
  circle(xPos,yPos,150); 
  fill(#0879FF);
  circle(xPos,yPos,100);
  fill(#FF0000);
  circle(xPos,yPos,50);
}  
