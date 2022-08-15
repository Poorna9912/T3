import java.io.*;
import java.util.*;
public class Area
{
 public static void main(String []args)
 {
   int i;
   double pi=3.14,area;
   Scanner sc= new Scanner(System.in);
   System.out.println("Enter radius of circle : ");
   i=sc.nextInt();
   area=pi*i*i;
   System.out.println("Area of Circle : "+area);
 }
}

