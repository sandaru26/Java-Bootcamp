class board {
  int x,y;
  
  //constructor
  board (){
    
  }
  
  
  void display(){
    
  for (int i=0;i<8;i++)
  {
    y = y+50;
    for(int j=0;j<8;j++)
    {
      
      fill(color(random(255),random(255),random(255)));
      rect(x, y,50,50);
      x = x+50;
      
    }
    y=0;
    x=0;
  }
  }

}
