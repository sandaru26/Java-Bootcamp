int rows = 6, cols = 6;
int x = 0, y = 0;
int NSERP = 3 , NSECP = 2;             //Number of Strickers for Each row for a Player and Each Column for Player
Strikers [][]player1;
Strikers [][]player2;
color Red =color(255, 0, 0);
color Blue =  color(0, 0, 255);


void setup(){
  
  size(600,600);
  player1 = new Strikers[NSECP][NSERP];
  player2 = new Strikers[NSECP][NSERP];
  
  for(int r=0; r < NSECP; r++){
    for (int c = 0; c < NSERP; c++){
      player1[r][c] = new Strikers (x,y,Red);
      x = x + 200;
    }
    y = y + 100;
    x = x- 500;
      
}
x = 0;
y = 400;

  for(int r=0; r < NSECP; r++){
    for (int c = 0; c < NSERP; c++){
      player2[r][c] = new Strikers (x,y,Blue);
      x = x + 200;
    }
    y = y + 100;
    x = x- 500;
      
}
  x=0;
  y=0;
}


void draw(){
  Board();
  for(Strikers[] row :player1){
    for(Strikers b: row){
      if(b!= null){
      b.display();
      }
  }
  //player1.display();
  //player2.display();
  
}
for(Strikers[] row :player2){
    for(Strikers b: row){
      if(b!= null){
      b.display();
      }
  }
}
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
  color col;
  int xPos;
  int yPos;
  
  //constructor
  
  Strikers(int x,int y, color paint){
    col = paint;
    xPos = x;
    yPos = y;
  }
  
  void display(){
    fill(col);
    ellipse(xPos+50,yPos+50,80,80);
  }
  
  //void check(){
   //mouseClicked(){ 
}
