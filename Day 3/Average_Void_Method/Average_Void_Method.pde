void setup(){
  averageFind(10,20,30);
  int avgFind=averageFindRtn(60, 20, 40);
  println("Average of Three numbers Using Retrun Method: " + avgFind);
}

void averageFind(int x, int y, int z){
  int result = (x + y + z)/3;
  println("Average of Numbers :" + result);
}

int averageFindRtn(int x, int y, int z){
  return (x + y + z)/3;
}
