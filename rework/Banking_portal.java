import java.util.Scanner;

class CustomException extends Exception {
	public CustomException(String message) {
		super(message);
	}
}
class Banking_portal {
 public void login() {
	Scanner l = new Scanner(System.in);
	System.out.println("Username");
	char usr_name = l.next().charAt(0);
	System.out.println("Pin");
	char pswd = l.next().charAt(0);
	if(((usr_name >= 99) && (usr_name <= 122)) && ((pswd >= 48 && pswd <= 57))) { 
		System.out.println("Welcome to the portal");
	}
	else {
		System.out.println("Wrong credentials");
		System.exit(0);
	}
 }	
 public void wtdrw() throws CustomException{
	 int balance = 10000;
	 Scanner w = new Scanner(System.in);
	 System.out.println("Enter the amount you want to withdraw");
	 int wtdrw = w.nextInt();
	 if(wtdrw > balance) {
		 throw new CustomException("insufficient funds");
	 }
	 else {
		 int rem_bal = 0;
		 rem_bal = balance - wtdrw;
		 System.out.println("Amount Withdrawn");
		 System.out.println("Remaining balance is "+rem_bal);
	 }
 }
 public void deposit() throws CustomException {
	 int balance = 10000;
	 Scanner d = new Scanner(System.in);
	 System.out.println("Enter the amount you want to deposit");
	 int deposit = d.nextInt();
	 if(deposit < 100) {
		 throw new CustomException("Your have to deposit more than 100/-");
	 }
	 else {
		 int rem_bal = 0;
		 rem_bal = balance + deposit;
		 System.out.println("Amount Deposited");
		 System.out.println("Remaining Balance is "+rem_bal);
	 }
}
 public static void main(String args[]) {
	 Scanner sc = new Scanner(System.in);
     Banking_portal b=new Banking_portal();
     b.login();
     System.out.println("Selct an option");
	 System.out.println(" 1.Withdraw Money"
	 		+ "\n 2.Deposit Money"
	 		+ "\n 3.View Balance"
	 		+ "\n 4.Exit");
	 int option = sc.nextInt();
	 switch(option) {
	 case 1: 
		 try {
			 b.wtdrw();
		 }
		 catch(CustomException e) {
			 System.out.println("[" + e +"] Exception Occured");
		 }
		 break;
	 case 2:
		 try {
			 b.deposit();
		 }
		 catch(CustomException e) {
			 System.out.println("[" + e +"] Exception Occured");
		 }
		 break;
	 case 3:
		 System.out.println("Your balance is 10000/-");
		 break;
	 case 4:
		 System.out.println("THANK YOU FOR BANKING WITH US");
		 break;
	 default:
		 System.out.println("Please contact Technical Support for further assistance");
		 return;
	 }
	 
 }

}

