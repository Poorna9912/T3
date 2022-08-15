import java.io.*;
import java.util.Scanner;
public class Cube
{
 public static void main(String args[])
 {
  int i,j;
  Scanner sc=new Scanner(System.in);
  System.out.print("eneter any value : ");
  i=sc.nextInt();
  j=i*i*i;
  System.out.println("The cube of given number " +i+ " is : " +j);
 }
}
