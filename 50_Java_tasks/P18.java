import java.util.Scanner;
 class P18
 {
  public static void Forloop()
  {
   System.out.println("Enter the number of even numbers you want...");
   Scanner sc = new Scanner(System.in);
   int n=sc.nextInt();
   int i=1;
   for(i=1;i<=n;i++)
   {
    int p=2*i;
    System.out.print(p+" ");
   }
  }
  public static void Whileloop()
   {
    System.out.println("Enter the number of even numbers you want...");
    Scanner sc = new Scanner(System.in);
    int n=sc.nextInt();
    int i=1;
    while(i<=n)
    {
     System.out.print(i*2+" ");
     i++;
    }
   }
  public static void Dowhile()
  {
  System.out.println("Enter the number of even numbers you want...");
    Scanner sc = new Scanner(System.in);
    int n=sc.nextInt();
    int i=1;
   do
   {
    System.out.print(i*2+" ");
    i++;
   }   
   while(i<=n); 
  } 
 public static void main(String args[])
 {
 Scanner sc=new Scanner(System.in);
 System.out.println("Select a looping Statement \n 1.For loop \n 2.While Loop \n 3.Do-While Loop");
 int num=sc.nextInt();
 switch(num)
 {
  case 1: Forloop();
  break;
  case 2: Whileloop();
  break;
  case 3: Dowhile();
  break;
  default: System.out.println("You have given an invalid input");
  return;
 }
}
}  
 
 
