import java.util.Scanner;
class P6
{
 public static void main(String args[])
 {
  char ch;
  System.out.println("Enter a letter or number or a special character");
  Scanner sc =  new Scanner(System.in);
  ch = sc.next().charAt(0);
  if(ch >= 65 && ch <= 90)
   System.out.print("Given is a Upper Case letter");
  else if(ch >= 97 && ch <= 122)
   System.out.print("Given is a Lower Case letter");
  else if(ch >= 33 && ch <= 64)
   {
    if(ch >= 48 && ch <= 57)
    System.out.print("Given is a Number");
    else
    System.out.print("Given is a Symbol");
   }
 }
}  
