import java.io.*;
import java.util.Scanner;
public class Month
{
 public static void main(String []args)
 {
  int month,year;
  Scanner sc=new Scanner(System.in);
  System.out.print("Month : ");
  month=sc.nextInt();
   System.out.print("year : ");
  year=sc.nextInt();
  if(month==1 ||month==3 ||month==5 ||month==7 ||month==8 ||month==10 ||month==12)
  {
   System.out.println("days in this month : 31 ");
  }
  else if(month==2 && month%4==0)
  {
  System.out.println("days in this month : 29 ");
  }
  else if(month==2)
  {
  System.out.println("days in this month : 28");
  }
  else {
  System.out.println("days in this month : 30");
 }
}}
