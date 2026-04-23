Ball ball1; //variable declaration
Ball ball2;
Ball ball3;

void setup(){
 size(600,500);
 ball1 = new Ball(5, 6, 15, color(random(255),random(255),random(255)));
 ball2 = new Ball (200,200,15, color(random(255),random(255),random(255)));
 ball3 = new Ball (300,100,15, color(random(255),random(255),random(255)));
}

void draw(){
  background (0);
  ball1.update();
  ball1.display();
  
  ball2.update();
  ball2.display();
  
  ball3.update();
  ball3.display();
}

class Ball {
  float x, y;
  float vx, vy;
  float radius;
  color col;
 
  
 Ball (float startX, float startY, float r, color color1){
   x = startX;
   y = startY;
   radius = r;
   col = color1;
   vx = 14;
   vy = 14;
 }
   
 
 void update () {
  
   x = x + vx;
   y = y + vy;
   
   if(x - radius < 0 || x + radius > width) {
     vx = -vx;
   }
   if (y -radius < 0 || y + radius > height){
     vy = -vy;
   }
 }
 
 void display () { 
   fill (col);
   ellipse (x, y, radius * 5, radius * 5);
 } 
}
