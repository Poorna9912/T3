import java.io.*;
import java.util.*;
public class Seconds
{
 public static void main (String []args)
 {
  int p1,p2,p3,seconds;
  Scanner sc=new Scanner(System.in);
  System.out.print("Eneter seconds : ");
  seconds=sc.nextInt();
  p1=seconds%60;
  p2=seconds/60;
  p3=p2%60;
  p2=p2/60;
  System.out.println(p2+ " : "+p3 +" : "+p1);
  System.out.println(" ");
 }
}
