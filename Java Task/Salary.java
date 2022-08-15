
 import java.io.*;
import java.util.Scanner;
public class Salary
{
	public static void main(String arg[])	
	{
	    double grossSalary,incomeTax,providentFund,professionalTax,netSalary;
	           Scanner sc = new Scanner(System.in);
	           System.out.print("The your salary to check Content :  ");
	           grossSalary = sc.nextDouble();
	           incomeTax = (2/grossSalary); 
	           providentFund = (700);    
	           professionalTax = (1550);
	           netSalary = grossSalary-(incomeTax + providentFund + professionalTax);
	           System.out.println("Net Salary is="+netSalary);
                   }
}
