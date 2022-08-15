abstract class java
{
int a=10;
int b=20;
void add()
{
}
}
class javap extends java
{
public static void main(String args[])
{
java j = new javap();
j.add();
System.out.println(j.a);
}
}
