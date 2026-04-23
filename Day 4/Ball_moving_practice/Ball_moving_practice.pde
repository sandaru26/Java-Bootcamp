//Ball ball1;
//Ball ball2;
Ball [] balls;
int numBalls=700;


void setup(){
  size(1000,400);
 // ball1 = new Ball(100 ,50 , 60, 5,2);
  //ball2 = new Ball(100, 100, 60, 2, 5);
  balls = new Ball[numBalls];
  
  for(int i=0;i<numBalls;i++)
  {
    balls[i] = new Ball(random(0,500),random(0,500),random(20,50),random(1,5),random(1,5));
  }
  
}

void draw(){
  //background(255);
  fill(0);
  for(Ball b: balls){
    b.display();
    b.move();
  }
  
    
  //ball1.display();
  //ball1.move();
  
  //ball2.display();
  //ball2.move();
  
}
  
 
class Ball{
  
  //Fields - data
  float x, y; //Ball position
  float radius;
  float vx, vy;
  color col;
  
  //Constructor
  Ball (float startX, float startY, float r, float vsx, float vsy){
    x = startX;
    y = startY;
    radius = r;
    vx = vsx;
    vy = vsy;
    col = color(color(random(255),random(255),random(255)));
  }
  
  void display(){
    fill(col);
    circle(x,y,radius);
  }
  
  void move(){
   x = x + vx;
   y = y + vy;
   
  if( x + radius/2 > width || x - radius/2 < 0)
  {
    vx = -vx;   
  }
  
  if( y + radius/2 > height || y - radius/2 < 0)
  {
     vy = -vy; 
  }
}
}
