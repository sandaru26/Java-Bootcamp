int[] studentMarks = {80, 30, 40, 50, 89};

void setup(){
  int sum = 0;
  int max= studentMarks[0];
  for(int i = 0 ; i < studentMarks.length; i++){
    println("marks" + i +" "+ studentMarks[i]);
    sum = sum + studentMarks[i];
    if(i < studentMarks.length-1)
    {
      if (max < studentMarks[i+1])
      {
        max = studentMarks[i+1];
      }
    }
  }
  int avg = 0;
  avg = sum/studentMarks.length;
  println("Sum is: " + sum + " Average is: " + avg + " Max Number is " + max);
}
  
