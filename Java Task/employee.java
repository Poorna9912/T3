class employee {
   public void display() {
      System.out.println("Inside display");
   }
}
class Rectangle extends employee {
   public void area() {
      System.out.println("Inside area");
   }
}
 class Tester {
   public static void main(String[] arguments) {
      Rectangle rect = new Rectangle();
      rect.display();
      rect.area();
   }
}
