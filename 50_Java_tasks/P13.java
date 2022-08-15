import java.util.Scanner;
 class P13
 {
  public static void main(String args[])
  {
   System.out.println("Enter a year and a month");
   Scanner sc = new Scanner(System.in);
   int year = sc.nextInt();
   int month = sc.nextInt();
    switch(month)
    {
     case 1 :
     case 3 :
     case 5 :
     case 7 :
     case 8 :
     case 10 :
     case 12 :
      System.out.println("This month contains 31 days");
      break;
     case 4 :
     case 6 :
     case 9 :
     case 11 :
      System.out.println("This month contains 30 days");
      break; 
     case 2 :
      if((year%400==0) || ((year%100!=0)&&(year%4==0)))
       System.out.println("This month contains 29 days");
      else
       System.out.println("This month contains 28 days");
      break;
     default : 
     System.out.println("invalid month");
     return;  
    }  
   }
 }      
   
     

