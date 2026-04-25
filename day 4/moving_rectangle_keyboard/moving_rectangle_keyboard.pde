int x = 0;
int y = 60;

void setup(){
  size(800,800);
  noStroke();
}

void draw(){
  
  if(keyPressed){
    if(key == 'w' || key == 'W'){
      y=y-2;
    }
    else if(key == 'a' || key =='A'){
      x=x-2;
    }
    else if(key == 's' || key == 'S'){
      y=y+2;
    }
    else if(key == 'd' || key == 'D'){
      x=x+2;
    }
  }
  //background (0);
  
  fill(0,0,0,40);
  rect(0,0,800,800);
  
  fill(255,0,0);
  rect(x,y,100,40);
  rect(x+50,y-20,50,20);
  ellipse(x+10,y+40,10,10);
  ellipse(x+80,y+40,10,10);
}
