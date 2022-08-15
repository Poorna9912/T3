
public class employeee {
float salary = 36000;
}
class programmers extends employeee
{
float bonus=80000;

public static void main (String args[])
{
	programmers p=new programmers();
	System.out.println("salary : "+p.salary);
	System.out.println("bonus : "+p.bonus);
}
}

