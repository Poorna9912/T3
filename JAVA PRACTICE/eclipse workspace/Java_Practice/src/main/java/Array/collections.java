package Array;

import java.util.ArrayList;
import java.util.Iterator;
public class collections {
public static void main(String args[]) {
	ArrayList <String> list = new ArrayList<String>();
	list.add("swetha");
	list.add("ravi");
	list.add("manu");
	list.add("siri");
//	System.out.println(list);
	 Iterator itr= list.iterator();
	  while(itr.hasNext())
	  {
	   System.out.println(itr.next());
	
			}
}
}
