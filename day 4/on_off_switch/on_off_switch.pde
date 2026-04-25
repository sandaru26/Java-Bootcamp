String status = "Off";
color col;

void setup(){
  size(400,300);
  
}

void draw(){
  background(0);
  fill(col);
  rect((width/2)-50,(height/2)-50,100,100);
  fill(0);
  textSize(50);
  text(status,width/2,height/2);
  textAlign(CENTER,CENTER);
  
}

void mouseClicked(){

{
  if(status == "Off"){
    status = "On";
    col = color(0,255,0);
    
  }
  
  else {
    status = "Off";
    col = color(255,0,0);
  }
}
}
    
  
