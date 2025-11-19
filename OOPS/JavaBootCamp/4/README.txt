BootCamp: 3rd September, 2025

The session focused on:
1. Applications of the static keyword, basic ideas and usage
2. Overriding vs hiding of static and non static variables and methods
3. Order of initialization in a multilevel inheritance scheme of static as well as non static initializer blocks and variables
4. Order of constructor calling

Since polymorphism has not been covered so far, the session only mentions compile-time vs run-time polymorphism, in the context of the static keyword.
Refer to ShadowingVsOverriding.java for how compile-time vs run-time polymorphism affects yout program- a simple explanation is provided.

All codes have comprehensive explanations alongside via comments.

The folder comprises 3 Java files:

1. ShadowingVsOverriding.java - Illutrates a basic example of how static and non static members of the class are invoked based on compile-time vs run-time polymorphism, with a SuperClass and a SubClass- 2 levels of inheritance.
2. InitializationOrderDemo.java - Detailed view of the order of initialization in Java of static and non static initializer blocks as well as variables.
3. StaticVariableDemo - 3 levels of Inheritance (Device --> Computer --> Laptop) with supporting code for you to play around with to ensure clear understanding of the above topics. 

Make the following changes to StaticVariableDemo.java:

Create a new class GamingLaptop that inherits from class Laptop. GamingLaptop should have:
1. A static variable CATEGORY="Gaming Laptop"
2. A non static variable id="G-004"
3. A static method printCategory() 
4. A non static method printId() that overrides its parent class method
See how these are defined in classes Device, Computer and Laptop and implement class GamingLaptop similarly.

In main(), add code that creates an object with compile-time type as Computer and runtime type as GamingLaptop. Using this object, invoke the printCategory() and printId() methods and print the data members id and CATEGORY. 

Additionally, invoke printCategory() of GamingLaptop without using an object (Hint: it is a static method).
Similarly, print CATEGORY of GamingLaptop without using an object.

Try to justify the output and make sure you understand why it is so.
Upload the updated file.
