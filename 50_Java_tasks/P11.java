import java.util.Scanner;
 class P11
 {
  public static void main(String args[])
  {
   System.out.println("Enter a Number or a Word");
   Scanner sc = new Scanner(System.in);
   char a=sc.next().charAt(0);
   if ( a >= 65 && a <= 122)
   {
    System.out.println("Given String contains characters");
    String c=Character.toString(a);
    int len;
    if(len == c.length)
    {
     System.out.println("Enter the digit you need");
     String i = sc.nextLine();
     System.out.println("The digit you entered is "+c.indexOf(i));
    }
    else 
     System.out.println("The Digit you need does not exist");  
   }
   else if(a >= 48 && a <= 57)
   {
    System.out.println("Given String contains Numbers");
    String n=Character.toString(a);
    int len;
    if(len == n.length)
    {
     System.out.println("Enter the character you need");
     String j = sc.nextLine();
     System.out.println("The digit you entered is "+n.indexOf(j));
    }
    else 
     System.out.println("The character you need does not exist");
   }
   else
    System.out.println("The given String is ALPHA-NUMERIC");
  }
 }      
