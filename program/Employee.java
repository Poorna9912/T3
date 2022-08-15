import java.util.*;
public class Manager extends Employee
{
	String Name;
	int Age,Salary,Employees;
	Scanner s=new Scanner(System.in);
	Name=s.nextLine();
	Age=s.nextInt();
	Salary=s.nextInt();
	Employees=s.nextInt();
	void display()
	{
		super.display();
		System.out.println("employees: "+Employees);
	}	
}

