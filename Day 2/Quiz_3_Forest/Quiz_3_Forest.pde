color leafColour, trunkColour;

void setup()
{
  size(800, 400);
  noStroke();
  leafColour  = color(82, 144, 97);
  trunkColour = color(95, 57, 26);
}

void draw()
{
  
  background(157, 238, 247);  // Sky
  fill(156, 245, 170);        // Ground
   
  rect(0, height/2, width, height/2);

  for (float xPos = 50; xPos < width; xPos = xPos + 100)
  {
    for (float yPos = 180; yPos < height; yPos = yPos + 150)
    {
      drawTree(xPos, yPos);
    }
  }
 
}

void drawTree(float treeX, float treeY)
{
  fill(#FFBC00);
  ellipse(width/4,height/6,50,50);
  fill(trunkColour);
  rect(treeX, treeY, 20, 70);
  fill(#FF6600);
  ellipse(treeX + 10, treeY - 30, 70, 90);
  
  
  
}
