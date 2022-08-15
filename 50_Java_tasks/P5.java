import java.util.Scanner;
 class P5
 {
  public static void main(String args[])
  {
   System.out.println("Enter the total percentage obtained");
   Scanner sc = new Scanner(System.in);
   double perc = sc.nextDouble();
   if(perc>50)
   {
    System.out.println("Passed");
    if (perc<=100 && perc>90)
     System.out.println("Rank 10.0");
    else if(perc<=90 && perc>80)
     System.out.println("Rank 9.0");
    else if(perc<=80 && perc>70)
     System.out.println("Rank is 8.0");
    else if(perc<=70 && perc>60)
     System.out.println("Rank is 7.0");
    else if(perc<=60 && perc>=50)
     System.out.println("Rank is 6.0");
   }     
   else
    System.out.println("Failed");
   }
  }   
