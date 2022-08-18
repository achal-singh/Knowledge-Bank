# Typescript

1. **Creating Config file for the TS Compiler** - `tsc --init`

## TS config File

2. **target**: Specifies the ES standard to which the TS file is compiled to.
3. **rootDir**: Specifies the location of the source files. Usually set to `/src`.
4. **outDir**: Specifies the location of the JS output/compiled files compiled by the TS compiler. Usually set to `/dist`.
5. **removeComments**: Removes comments from the compiled JS code to make it shorter.
6. **noEmitOnError**: Should be set to `true` to check for mistakes in the code without generating JS files.
7. **sourceMap**: Specifies how TS code is mapped to JS code.

-> Command to compile all TS files: `tsc` (Creates and stores all the resulting JS files at `outDir` location)

## Debugging using VS Code

8. Inside of Debug Panel, create `launch.json` file and add this line - `"preLaunchTask": "tsc: build - tsconfig.json"`. This line instructs VS code to use typescript compiler to build the code using tsconfig.json configurations.

## Fundamentals of TS

1. Typescript extends the list of primitive data types in JS ( number, string, boolean, object, symbols) and adds: **any, unknown, never, enum, tuple**.
   -> long number values like 1000000 in TS can be defined as 1_000_000
2. To turn off error messages for implicit **_any_** type, set the noImplicitAny property in tsconfig.json file to **false**. **THIS IS NOT RECOMMENDED**.
3. Tuples are fixed length array where each element has a particular type.

   Example:

   ```
   const user: [number, string] = [1, 'John Doe'];
   ```

4. Tuples may be defines as arrays of whatever fixed length we want, but should be limited to 2 for better understanding.

5. Enum is a list of related constants.
   Example:

   ```
   enum Size = {Small, Medium, Large}; // 0,1 and 2 is assigned as a default value to the three enums values.

   const enum Size = {Small = 1, Medium, Large};

   enum Size = {Small = 'S', Medium = 'M', Large = 'L' }; //Values can be explicitly defined as well.
   ```

6. **Functions** -

   ```
   Basic function structure:
   function thisIsAFunction(firstParam: number): number {
     return number * 1000;
   }
   ```

`tsconfig.json` file tip:

7.  `noUnusedParameters` may be set to true to check for unused parameters.

8.  `noImplicitReturns` when set to true, raises a warning when a function doesn't return an explicit value in a specific scenario.

9.  `noUnusedLocals` when set to true, checks and reports any unused variables.

10. `noImplicitAny` When enabled, the compiler will warn you about variables that are inferred with the any type. You’ll then have to explicitly annotate them with any if you have a reason to do so.

11. **Objects** -

    ```
    let employee: {
      readonly id: number;
      name: string;
      retire: (date: Date) => voi;
    } = { id: 1, name: 'John Doe', retire: (date: Date) => { console.log(date)
    }
    }
    -> A property may be set to "readonly" to avoid any mutations to it. So doing the following will give an error: employee.id = 2;
    ```

12. **Union Type** -
    Example:
    Below `name | string` is a **_Union_** Type.

    ```
    function kgToLbs(weight: number | string): number {
      if (typeof weight === 'number')
        // Narrowing variable weight to the "number" type
    }
    ```

13. **Intersection Type** - Example:

    Below `Draggable & Resizable` is an **_Intersection_** Type, which basically means that the varibale will support all the required properties of `Draggable & Resizable` types.

        ```
        type Draggable = {
          drag: () => void
        }

        type Resizable = {
          resize: () => void
        }

        type UIWidget = Draggable & Resizable

        let textBox: UIWidget = {
          drag: () => {}
          resize: () => {}
        }
        ```

14. **Literal Type** - To limit the value of a variable.

    ```
    // Literal (exact, specific)
    type Quantity = 50 | 100;
    let quantity: Quantity = 100;
    // The above variable can only hold 50 or 100 as its value.

    // Literal types can also be defined for strings or any other type.
    type Metric = 'cm' | 'inch'
    ```

15. **Optional Chaining** - The Optional Access Operators in TS help in dealing with cases where there's a possibility of getting a **_null_** or **_undefined_** value. With this approach the statement gets executed only when the property or array or function is NOT null or undefined else null or undefined are returned.

    ```
    type Customer = {
      birthday: Date
    }

    function getCustomer(id: number): Customer | null | undefined {
      return id === 0 ? null : { birthday: new Date() }
    }

    let customer = getCustomer(0);
    // Optional property access operator (?)
    console.log(customer?.birthday); // prints undefined

    // Optional element access operator (?.[index])
    // In case of accessing an array element => customers?.[0]

    // Optional call operator (?.())
    // In case of calling a function if its not null or not undefined => log?.('a')
    ```

16. **Nullish Coaelscing Operator (??)** - This operator checks for **_null_** and **_undefined_** values in a variable and returns the default value, placed after the `??` operator, only if the variable is null or undefined.

    ```
    let speed: number = 0;
    console.log(speed ?? 50) // 0

    let speed: number = null;
    console.log(speed ?? 50) // 50
    ```

17. **Type Assertions** - When we're certain about the type of an expression/variable we use type assertion to tell the TS compiler the type we want that expression to be treated as, and for this we use the **`as`** keyword.s

    > Note: Type assertion DOES NOT perform any type conversion under the hood, it only **_asserts_** the type we instruct.

    ```
    let phone = document.getElementById('phone') as HTMLInputElement
    console.log(phone.value)
    OR
    let phone = <HTMLInputElement> document.getElementById('phone')
    ```

18. **Unknown Type** - When we're unsure of the type of a variable it is suggested that we use **_unknown_** type over the **_any_** type. Similar to **_any_** type it can represent any value but cannot perform any operations on the **_unknown_** type. In our code though, we can handle the unknown type using type Narrowing by checking for variable's primitive type using `typeof` and custom type using `instanceof`.

19. **Never Type** - In case we have a function taht executes for infinite amount of time (like an always true while loop, error throwing function) we should declare its return type as `never` as it tells TS compiler that any expression after this function call won't be executed.

> Note: tsconfig.json property - **`allowUnreachableCode`**. It should be set to **`false`** to check for unreachable code in a project. In order for this setting to report any unreachable code we must use the **`never`** type.k

<hr/>

## Classes & Interfaces

<hr/>

> **Programming Paradigms** :-
>
> - Procedural
> - Functional
> - Object-oriented
> - Event-driven
> - Aspect-oriented etc.

20. **Class** - A normal class definition in TS looks like this:

    ```
    class Account {
      id: number;
      owner: string;
      balance: number;

      constructor(id: number, owner: string, balance: number) {
        this.id = id;
        this.owner = owner;
        this.balance = balance;
      }

      deposit(amount: number): void {
        if (amount <= 0) throw new Error('Invalid Amount');
        this.balance += amount;
      }

    // Creating an instance/object of the class
    const account = new Account(1, 'John Doe', 0);
    account.deposit(99);
    }
    ```

On compiling the code above, we get a JS file without any property definitions as properties and their types are exclusive to TS only not JS, rest everything is same.

### Access Modifiers, Read-only & Optional Properties

21.**Access Modifiers** - All properties when defined are **_public_** by default.

22. **readonly** - This keyword when prefixed to a class property makes it immutable everywhere **_except for the constructor of the class_**.

23. **private** - This keyword makes the variable accessible only inside of the class it is a member of. By convention we prefix private properties with an underscore **(\_)**. Similarly when methods are prefixed with **`private`** keyword, they're only accessible within the class and not via instances/objects of the class.

NOTE: **Shorthand declaration and initialization of a constructor in TS:**

Member variable declarations and initializations in a class like this:

```
class Account {
  readonly id: number;
  owner: string;
  private balance: number;
  nickname?: string;

  constructor(id: number, owner: string, balance: number) {
    this.id = id;
    this.owner = owner;
    this.balance = balance;
  }
}
```

Can also be written as the following in a more concise way:

```
class Account {
  nickname?: string;
  constructor(public readonly id: number, public owner: string, private balance: number) {}
}
```

24. **Getters & Setters** - A **Getter** is nothing but a method in our class which is used to access a property of the class and similarly a **Setter** method helps in changing the value of a class property.

    ```
    class Account {
     private _balance: number;

      // Getter
      get balance(): number {
        return this._balance;
      }

      // Setter
      set balance(value: number) {
        if (value < 0) throw new Error('Invalid Value');
        this._balance = value;
      }
    }

    const account = new Account(1, 'John Doe', 0);

    // Using the setter
    account.balance = 200;

    // Using the getter
    console.log(account.balance);
    ```

25. **Index Signature Property** - This is a special type of property using which a particular type of properties can be created dynamically.

    In the following example we're creating dynamic seat number properties:

    ```
    class SeatAssignment {
      [seatNumber: string]: string;
    }

    let seats = new SeatAssignment();
    seats.A1 = 'John Doe'
    seats.A2 = 'Jane Doe'
    ....
    ```

26. **Static Members** - A static property is a property that **_belongs to the class_** and not **_an object instance_**. So a single instance of a static peropty is stored in the memory.

    ```
    class Ride {
      private static _activeRides: number = 0;

      start() {
        Ride._activeRides++;
      }
      stop() {
        Ride._activeRides--;
      }
      static get activeRides() {
        return Ride._activeRides;
      }
    }

    let ride1 = new Ride();
    ride1.start();

    let ride2 = new Ride();
    ride2.start();

    console.log(Ride.activeRides); // 2
    ```

27. **Inheritance** - When we need to re-use a certain set of properties of a class (Parent/Base/Super Class) in other multiple classes (Child/Derived/Sub Class) we **_inherit_** those properties.

    ```
    // Parent/Base/Super Class
    class Person {
      constructor(public firstName: string, public lastName: string) {}

      get fullName() {
        return this.firstName + ' ' + this.lastName;
      }

      walk() {
        console.log('Walking');
      }
    }

    // Child/Derived/Sub Class
    class Student extends Person {
      // Here we've removed the public keyword from firstName and lastName variables
      // as we've already created those properties in the Person class.
      constructor(public studentId: number, firstName: string, lastName: string) {
        super(firstName, lastName);
      }

      takeTest() {
        console.log('Taking a Test');
      }
    }
    let student = new Student(1, 'John', 'Doe');
    student.walk(); // Inherited from Person class
    console.log(student.fullName);  // Inherited from Person class
    ```

28. **Method Overriding** - It means changing the parent class' method's implementation in a child/sub class. We prefix `override` keyword while overriding the method.

    > Note: tsconfig.json property - `noImplicitOverride` When enabled, then compiler will warn us if we try to override a method without using the **_override_** keyword.

    ```
    class Teacher extends Person {
      override get fullName() {
        return 'Professor ' + super.fullName;
      }
    }
    ```

    > **Polymorphism** - The word means **"Many forms"** which basically means the ability of a class to support multiple functionalities through the means of Inheritance. For ex- The **Person** class in the examples above took various forms as a **Teacher** and **Student**.

    > **Open Closed Principle** - Classes should be **open** for **extension** and **closed** for **modification**. This can't be followed all the time but it is advised to be followed as much as possible.

29. **private vs protected** - Private methods are only accessible within the class in which they're defined and not by class objects and child classes, whereas, protected methods are also not directly accessible by class objects but are accessible by child classes.

30. **Abstract Class** - Such classes are simple or **_not ready_**, so another class must **extend** it. Similarly, we have abstract methods in an abstract class which are also required to be implemented or defined by the class that extends the abstract class. Since abstract classes don't have an implementation of their own that's why there's **_no object instantiation allowed_** for an abstract class. Abstract is purely a TS concept and is absent in JS.

    ```
    abstract class Shape {
      constructor(public color: string) {}

      abstract render(): void; //abstract method
    }
    ```

31. **Interface** - It is used to define the shape or structure of an object. Interfaces are not supported in JS.

        > Note: Abstract Class vs Interface - An interface is a better choice in case we don't have any coded logic implemented inside of the abstract class as it is more concise.

        ```
        interface Calendar {
          name: string;
          addEvent(): void;
          removeEvent(): void;
        }

        // CloudCalendar has access to all Calendar fields and
        // may add more fields
        interface CloudCalendar extends Calendar {
          sync(): void;
        }

        class GoogleCalendar implements Calendar {
          constructor(public name: string) {}

          addEvent(): void {
            throw new Error('Method not implemented.');
          }
          removeEvent(): void {
            throw new Error('Method not implemented.');
          }
        }
        ```

32. **Interface vs Types** - Interfaces and type aliases can be used interchangeably. Both can be used to describe the shape of an object:

    ```
    interface Person {
      name: string;
    }
    let person: Person = { name: 'John'
    type SamePerson = { name: string
    let samePerson: SamePerson = { name: 'John' };
    ```

    A class can also implement both as follows:

    ```
    class Person extends Person {}
    class Person extends SamePerson {}
    ```

    However, it is more conventional to use an interface in front of the **_extends_** keyword.

    BUT, unlike an interface, the type alias can also be used for other types such as primitives, unions, and tuples.

    ```
    // primitive
    type Name = string

    // object
    type PartialPointX = { x: number; };
    type PartialPointY = { y: number; }

    // union
    type PartialPoint = PartialPointX | PartialPointY

    // tuple
    type Data = [number, string];
    ```

    Also, both can be extended and are mutually exclusive.

    ```
    // Interface extends interface
    interface PartialPointX { x: number; }
    interface Point extends PartialPointX { y: number; }

    // Type alias extends type alias
    type PartialPointX = { x: number; };
    type Point = PartialPointX & { y: number; };

    // Interface extends type alias
    type PartialPointX = { x: number; };
    interface Point extends PartialPointX { y: number; }

    // Type alias extends interface
    interface PartialPointX { x: number; }
    type Point = PartialPointX & { y: number; };
    ```

    A class can implement both types and interfaces in the same way. However, since they are both considered as **static** blueprints, a class won't implement a union type.

    ```
    interface Point {
      x: number;
      y: number;
    }

    class SomePoint implements Point {
      x = 1;
      y = 2;
    }

    type Point2 = {
      x: number;
      y: number;
    };

    class SomePoint2 implements Point2 {
      x = 1;
      y = 2;
    }

    type PartialPoint = { x: number; } | { y: number; };

    // FIXME: can not implement a union type
    class SomePartialPoint implements PartialPoint {
      x = 1;
      y = 2;
    }
    ```
