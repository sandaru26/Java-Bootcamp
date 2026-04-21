void setup(){
  size(400,400);
}

void draw(){
  background(255);
  
  for(int i=0; i < 8; i++)
  {
    for(int j = 0; j < 8; j++)
    {
      if( (i+j)%2 == 0)
      {
        fill(0);
      }      
      else
      {
        fill(255);
      }
      rect(50*i,50*j,100,100);
    }
}
}
