## 🕹️ Control flow 
Control flow refers to how a program runs and the order that it follows. It decides which statements, instructions or function calls are executed and in what order, based on conditions or decisions made during the run time.

In Motoko, we find the common control flow operators:

- `if`/ `else`: these allow the program to make a decision and execute a certain block of code only if a specific condition is met. The optional else statement provides an alternative if the condition is not met.
```motoko
    func is_even(n : Nat) : Bool {
        if(n % 2 == 0){
            return true
        } else {
            return false
        };
    };
```
In many cases the `else` block can be removed without modyfing the behavior of the code block:
```motoko
    func is_even(n : Nat) : Bool {
        if(n % 2 == 0){
            return true;
        };
        return false;
    };
```
- **Loops**: these allow a block of code to be executed repeatedly until a specific condition is met. There are several types of loops, including `for` loops & `while` loops. 

    - `for` loops in Motoko involves using an iterator of type `Iter`. If you are not familiar with `Iter`, don't worry it's a concept that we will explain later on. 

        ```motoko
        var count : Nat = 0;
        let i = Iter.range(0, 10);
        for (x in i) {
            count += 1;
        };
        ```

    - We can also use `while` loops.

        ```motoko
        var count : Nat = 0;
        while (count < 10) {
            count += 1;
        };
        ```
There are other ways to do control flow in Motoko with instruction such as `do?`or with `switch` that we see later on. 

## ❌ Errors
[TODO: ADD LINE INDICATION] <br/>
Sometimes things go wrong - that's life! <br/> Fortunately, in most cases reading the error message carefuly will be enough to identify & resolve the error. 
There are different types of errors in Motoko:

- **Type error**: this is probably the most common type. This happens when your program in expecting **type X** and you're providing **type Y**. 

For instance the following code wouldn't compile and would throw a **type error**:
```motoko
actor {
    var name : Text = "Motoko";

    public func changeName(newName : Text) : async Nat {
        name := new_name;
        return name;
    };
}
```

We are indicating that the return type of `changeName` is a `Nat` but we are returning `name` which is of type `Text`. 
In this case, the compiler will indicate:
```motoko
expression of type
  Text
cannot produce an expected type
  Nat
```

- **Syntax error**: this happens when there is an error in the way you wrote your code - such as:
    - Forgetting a symbol: `+`, `-`, `;`...
    - Forgetting a keyword: `actor`, `func`, `return`, `var`, `let`...
    - Mispelling a variable name.

For instance if we forget one bracket `{` to close the body of the function:

The following code would return an error
```motoko
actor {
    var name : Text = "Motoko";
    public func changeName(newName : Text) : async Nat {
        name := new_name;
        return name
}
```
`syntax error [M0001], unexpected end of input, expected one of token or <phrase> sequence: }`

- Trap: A trap is like a "time-out" for your code. Contrary to the two previous errors that are detected at compile time, a trap is an error that happens during execution, and when it does, the program will stop and give you an error message, indicating that something went wrong. A few examples are:
    - Division by 0. 
    ```motoko
    let a : Nat = 5;
    let b : Nat = 0;
    let c = a / b;
    ```
    - Accessing an index out of bounds 
    ```motoko
    let words : [Text] = ["table", "boat, "ghost"];
    let word : Text = words[4];
    ```
    - Assertion failure.
    ```motoko
    assert(false)
    ```

> Trapping will only stop the execution of the current message and not prevent the canister from answering subsequent requests.
