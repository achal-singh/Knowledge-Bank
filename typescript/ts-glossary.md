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

13. **Intersection Type** -

Example:
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
