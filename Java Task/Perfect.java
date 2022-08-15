import  java.util.*;
import java.io.*;
public class Perfect
{  
 public static void main(String []args)
 {  
  int i,num,sum=0;
  Scanner sc=new Scanner(System.in);
  System.out.print("Enetr the value to check perfect or not : ");  
  num=sc.nextInt();
  for(i=1;i<num;i++)
  {
  if(num%i==0)
  sum=sum+i;
  }
  if(sum == num)
  {
   System.out.println("The given number is perfect ");
  }
  else 
  {
  System.out.println("The given number is not perfect number ");
  }

}  
}     
 
