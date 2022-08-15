import  java.util.*;
import java.io.*;
class Palandrome
{  
 public static void main(String []args)
 {  
  int r,temp,sum=0;    
  int n;
  Scanner sc=new Scanner(System.in);
  System.out.print("Enetr the value to check palandrome or not : ");  
  n=sc.nextInt();
  temp=n;    
  while(n>0)
  {    
   r=n%10;   
   sum=(sum*10)+r;    
   n=n/10;    
  }    
  if(temp==sum)    
   System.out.println("palindrome number ");    
  else    
   System.out.println("not palindrome");    
}  
}  
