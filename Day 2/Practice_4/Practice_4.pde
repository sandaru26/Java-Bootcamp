float xPos;
float vx;
String message;

void setup()
{
  size(600, 100);
  fill(255, 177, 8);
  textSize(48);

  xPos = width;
  vx = -2;
  message = "The next station is Angel...";
}

void draw()
{
  background(64);

  xPos = xPos + vx;

  if (xPos < -textWidth(message))
  {
    xPos = width;
  }

  text(message, xPos, (height/2) + 20);
  println("xPos" + xPos + " vx "+ vx + " Message "+ message);
}
