int rows = 6;
int cols = 6;
int x = 0, y = 0;
Strikers player1;
Strikers player2;

void setup(){
  
  size(600,600);
  player1 = new Strikers();
  player2 = new Strikers();
}

void draw(){
  Board();
  Strikers.display();
}

void Board() {
  
  for(int r=0; r < rows; r ++){
    for (int c=0; c < cols; c++){

      if((c+r)%2 == 0 )
      {
        fill(0);
      }
      else 
      fill(255);
      rect(x,y,100,100);
      x = x + 100;
    }
      y = y + 100;
      x = 0;
  } 
}

class Strikers{
  
  //fields 
  color Red =color(255, 0, 0);
  color Blue =  color(0, 0, 255);
  
  //constructor
  
  Strikers(){
     
  }
  
  void display(){
    
    cricle(x,y,40);
  }

}
