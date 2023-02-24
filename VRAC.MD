



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
## 🏭 Classes
Classes are factories for constructing object. A class allows us to define a type that can take on parameters and functions. Functions that are attached on the object are usually called **methods**.
```motoko
class Student(_name : Text, _age : Nat, _score : Nat) {
    public let name : Text = _name;
    public var age : Nat = _age;
    public var score : Nat = _score;
    public func study() {
        score +=1;
    };
};
```
Once the `Class` is defined we can easily create new instances by providing parameters.
```motoko
let John : Student = Student("John Doe", 25, 0);
``` 

`Class` is just a keyword that provides syntaxic sugar - we could also write the following: 
```motoko
type Student = {
    name : Text;
    var age : Nat;
    var score : Nat;
};

func Student(_name : Text, _age : Nat, _score : Nat) : Student = object {
    public let name : Text = _name;
    public var age : Nat = _age;
    public var score : Nat = _score;
    public func study() {
        score +=1;
    };
};
```

## 🫙 Optional type
In Motoko `null` is a special value that represents the absence of result. The value `null` is of type `Null` (and the type `Null` only contains only the `null` value). <br/> 
An optional type, is a type that can either hold a value or "nothing". It is a way to represent the possibility that a value may be absent. We use the `?` symbol to indicate an optional type.
<br/>

For instance, if we have a value of type: `?Text` (optional Text) it means that the value can either be:
- A value of type `Text`.
- The `null` value.

An optional type can be: `?Nat`, `?Bool`, `?Char` or any other existing type.
Optional types are often used with the `switch/case` pattern. This pattern allows you to handle an optional value and execute different parts of your code depending on whether the input value is `null` or not. This allows for more elegant and safer code as it allows you to handle the case where the input is null and avoid any unexpected behavior.

```motoko
public func handleOptionalNat(n : ?Nat) : async Nat {
    switch(n){
        case(null){
            return 0
        };
        case(? some){
            return some
        };
    };
};
```

A module from the base library called [Option](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/base/Option) provide utilities functions to perform operations on optional values.

[TODO: ADD IMAGE] 
<br/>
For instance, you can use `Option.get()` to unwrap an optional value. (i.e take a `?Nat` as input and return a `Nat`)
- If you provide a `Nat` as input it will return the same value.
- If you provide `null` it will return the default value - which we can set to 0. <br/>
We can use this method to rewrite `handleOptionalNat()` 
```motoko
import Option "mo:base/Option";
actor {
    public func handleOptionalNat(n : ?Nat) : async Nat {
        Option.get(n, 0);
    };
}
```

## 🔮 

**Typing** refers to the way in which data types are defined and checked in a programming language. There are two main approaches to typing: nominal typing and structural typing.

In Motoko, the question of whether two types (or classes) are equal is based on their structure, not their names. This property is called **structural typing**. <br/>

What does it mean exactly? Let's imagine that we define two types.

```motoko
class Student(_name : Text,  _score : Nat) {
    public let name : Text = _name;
    public var score : Nat = _score;
};  

class Player (_name : Text,  _score : Nat) {
    public let name : Text = _name;
    public var score : Nat = _score;
}
```
Those two types are considered equal from the point of view of the language. 
Indeed, we can write the following, and it's correct! 
```motoko
let John : Student = Player("John Doe", 0);
let Emma : Player = Student("Emma Smith", 0);
```

> Nominal types are rather problematic in a distributed setting, since somebody will “own” their definition locally. That is, you cannot really use them easily for messaging. So it was natural to avoid them when designing the Motoko language. 

