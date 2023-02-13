# Day 3️⃣
- 🔮 Structural typing vs Nominal typing
- List
- Classes
## 🗃️ Arrays
In Motoko, an array of type `Array` is a group of **similar** elements that are stored together. To create an array, one must specify the types of elements that the array will contain. 
For instance, to create an arrray that will hold `Nat`.
```motoko
let ages : [Nat] = [16, 32, 25, 8, 89];
```
An array that will hold values of type `Text`.
```motoko
let words : [Text] = ["Motoko", "is", "the", "best", "language"];
```
Contrary to other programming languages which might be more flexible in that regard, in Motoko we can't mix elements of different types in the same array. The following code will throw an error: `literal of type Text does not have expected type Nat`. 
```motoko
let array : [Nat] = [14, 16, 32, 25, "Motoko"];
```

<p align="center"> <img src="./img/array.png" width="600px" style="border: 2px solid black;"></p>

To access a specific element within an array, we use its index. Keep in mind that arrays in Motoko are zero-indexed, which means that the first element is at position 0, the second element is at position 1, and so on. For example, to access the first element of an array named `myArray`, we would use `myArray[0]`, and to access the second element, we would use `myArray[1]`.
```motoko
let myArray : [Nat] = [23, 16, 32, 25];
let a = myArray[0]  // 23
let b = myArray[3]  // 25
```
We can access the size of an array using the `.size()` method.

```motoko
let names : [Text] = ["Emma Smith", "Olivia Johnson", "Ava Brown", "Isabella Davis"];
let size = names.size();    // 4
```

To loop over an array we can use the `.vals()` iterator. Here is an example that would gave us the sum of an array.
```motoko
actor {
    let array : [Nat] = [1, 2, 3, 4, 5];
    var sum : Nat = 0;

    public func somme_array() : async Nat {
        for (value in array.vals()){
          sum := sum + value;
        };
       return sum; 
    };
};
```

In Motoko, arrays have a fixed size that is determined when the array is created. This means that the size cannot be increased later on. To add a new element to an array, a new array must be created and all of the existing elements must be transferred to the new array manually. This makes `Array` not really adapted for datastructures that needs be constantly updated. 

Concatenating two arrays to an `Array` can be done using `Array.append()` - a function from the [Array](https://internetcomputer.org/docs/current/motoko/main/base/Array) module. 
```motoko
let array1 = [1, 2, 3];
let array2 = [4, 5, 6];
Array.append<Nat>(array1, array2) // [1, 2, 3, 4, 5, 6];
```
However, this function is **depreceated**. It is recommended to avoid it in production code. That's because as we've said before it is impossible to simply add elements to an array. Under the hood, `Array.append()` will create a new array and copy the values of the two existing arrays which is not efficient. 
## 🪨 Immutable or Mutable?
Arrays are also immutable by default, just like variables declared with "**let**". This means that the values inside an array can be read but not modified. 

> Accessing elements within an array is quick and efficient due to the immutability of arrays. Since the size of an array is established at the time of creation and the memory locations for all elements are predetermined, accessing elements is straightforward. The memory allocation for an array is determined by its fixed size, and the position of the first element is known, making it possible to calculate the location of all other elements. It is not necessary to have a deep understanding of computer memory management for this lesson, but it's worth mentioning that accessing elements in arrays is efficient, but adding new elements is not.

The following code would throw an error:
```motoko
let dates : [Nat] = [1, 3, 6];
dates[0] := 5;
```
> **Error in file Main.mo:2:0 expected mutable assignment target**

It is possible to create mutable arrays but just like variables and objects you have to use the keyword `var`. 
```motoko
let mutable_dates : [var Nat] = [var 1, 3, 6];
```
Mutable arrays permits updates of the elements inside the array.
```motoko
mutable_dates[0] := 5; //[5, 3, 6];
mutable_dates[2] := 1; //[5, 3, 1];
```
Mutable and immutable arrays **do not have the same type**. Which means that it is not possible to use a mutable array of type `[var X]` in places that expect an immutable one of type `[X]` and the same for the opposite.
## 🤫 Mutable state
In Motoko, actors are restricted from sharing a mutable state. Mutable data must always be kept private and can never be shared remotely. This rule has been designed to simplify your programming experience. It prevents multiple actors from simultaneously modifying a shared variable without knowledge of the other actors' actions. Otherwise this would cause confusion and make programming with actors way more difficult.

<p align="center"> <img src="./img/mutable_state_actor.png" width="800px" style="border: 2px solid black;"></p>

In practice this means that sharing a mutable array is not possible.
```motoko
actor {
    let mut : [var Nat] = [var 1, 5, 3];

    public func getArray() : async [var Nat] {
        return mut;
    };
};
```
The previous code would result in the following error: `shared function has non-shared return type [var Nat] type [var Nat] is or contains non-shared type var Nat`.

If one wants to share a mutable array with the outside world (another actor or user), one has to converts it to an immutable array before sharing it. This can be done with the `Array.freeze()` function. We can use it to correct the previous code block.
```motoko
import Array "mo:base/Array";
actor {
    let mut : [var Nat] = [var 1, 5, 3];

    public func getArray() : async [Nat] {
        let immutable = Array.freeze<Nat>(mut);
        return immutable;
    };
};
```
## 🥞 Buffer
A more adapted structure to dynamically add new elements is the type `Buffer`. 
A `Buffer` can be instantiated using the [Buffer](https://internetcomputer.org/docs/current/motoko/main/base/Buffer) library. 
One needs to provide the types of elements stored inside and the initial capacity. 
The initial capacity represents the length of the underyling array that backs this list. In most cases, you will not have to worry about the `capacity` since the Buffer will automatically grow or resize the underlying array that holds the elements.
```motoko
import Buffer "mo:base/Buffer";
actor {
    let b = Buffer.Buffer<Nat>(2);
}
```
In this case, the types of elements in the buffer is `Nat` and the initial capacity of the buffer is `2`. 

To add an element use the `.add()` method.
```motoko
b.add(0);   // add 0 to buffer
b.add(10);   // add 10 to buffer
b.add(100)    // causes underlying arrray to increase in capacity since the capacity was set to 2
```
To get the number of elements in the buffer use the `.size()` method. The `size` is different than the capacity we've mentionned earlier since it represents the number of elements that are actually stored in the buffer.
```motoko
let b = Buffer.Buffer<Nat>(2);
b.add(0);   
b.add(10);   
b.add(100);  
b.size();   // 3
```
To access an elements in the buffer, use the `.get()` method and provides the index. 
```motoko
let b = Buffer.Buffer<Nat>(2);
b.add(0);   
b.add(10);   
b.add(100);  
b.get(2);   // 10
```
Traps if `index` >= `size`. Indexing is zero-based like with `Array`.
A buffer can easily be converted to an array using the `toArray()` function from the [Buffer library](https://internetcomputer.org/docs/current/motoko/main/base/Buffer#function-toarray-1).


```motoko
let b = Buffer.Buffer<Nat>(2);
b.add(0);   
b.add(10);   
Buffer.toArray<Nat>(b); // [0, 10];
```

## 👤 Generic Type
A generic type, usually written as `T`, allows you to write functions and code that can adapt to different types. When we talk about `T`, it refers to **whatever type you want**. This means that you can create a single function or class that can handle multiple types of inputs or data, without having to write separate code for each type.

Let's imagine that we have a task at hand - to determine if the size of an array is even or not. We're going to write a function called `isArrayEven` that takes an array as an input and returns a `Bool` value indicating whether the size of that array is even or not.
```motoko
public func isArrayEven(array : [Nat]) : async Bool {
    let size = array.size();
    if(size % 2 == 0){
        return true;
    } else {
        return false;
    };
};
```
This function works as intended, but is limited to arrays filled with `Nat`. So, what if we want to check the size of an array filled with `Text` or `Int`? <br>
One approach would be to create a separate function for each possible type: 
- `isArrayEvenNat`
- `isArrayEvenText`
- `isArrayEvenInt` 

As you can imagine, this quickly becomes hard to manage and maintain. A better solution is to utilize the power of generics. With generics, we can write a single function that works for any type of array. It's a more elegant and efficient way to solve the problem. So, let's embrace our new friend - generics - and make our code more dynamic and flexible!
```motoko
func isArrayEven<T>(array : [T]) : Bool {
    let size = array.size();
    if(size % 2 == 0){
        return true;
    } else {
        return false;
    };
};
```

Notice `<T>` following the name of the function. It means that this function now depends on the type of `T`. We need to specify the type of `T` when we want to use the function.
```motoko
let array : [Nat] = [1,2,3,4];
let bool : Boolean = isArrayEvent<Nat>(array); // Replace T with the actual type when you use the function. 
```

We've  already used generics when playing with `Buffer` & `Array` without talking about it. 
- The type `Buffer<T>` is a generic class and we need to provide a type when creating a new buffer.
    ```motoko
    let b = Buffer.Buffer<Nat>(2);
    ```

- `Array.append<T>` is a generic function and we need to provide the type of the elements of the arrays we are concatening.
    ```motoko
    let array1 = [1, 2, 3];
    let array2 = [4, 5, 6];
    Array.append<Nat>(array1, array2) // [1, 2, 3, 4, 5, 6];
    ```


