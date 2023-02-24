# Day 5️⃣
- Packages with Vessel & Mops
- Add how to throw an Error with the Error library.

## 🎰 Randomness
Providing randomness to canisters on the Internet Computer is tricky: all computations perfomed by nodes needs to be deterministic; if one or multiple node(s) would diverge and compute a different result at any round, we would be at risk of breaking the consensus! 

We need to have access to randomness that is:

- Unique (same for all nodes).
- Unpredictable (no one node or malicious actor can guess it beforehand).
- Unstoppable (no one node or malicious actor can stop a dApp to access to randomnes). 

Under the assumptions of the consensus (less than 1/3rd of the nodes are malicious), the Internet Computer provides an API that gives access to **true randomnes** to all canisters that satisfies the 3 required properties. 

> The randomness is generated every round, from a random tape. The random tape is obtained using Threshold BLS signatures that satifisfies the 3 properties we've mentionned (unpredictable, unique, unstoppable). If you want to know more about the construction, you can [watch the dedicated video](https://www.youtube.com/watch?v=nl5BuiWClD0).

In Motoko, we can access to the API using the dedicated [Random library]() to request 32 bytes of entropy.
```motoko
let entropy = await Random.blob();
```
> Due to the construction of the random tape, requests to get entropy are answered asynchronously using `await`. However, the obtained entropy is only truly random for one round and must be refueled at each round to remain valid.

The entropy can be used to create a instance of the `Finite` class. The `Finite` class provide methods to obtain random values. 
```motoko
let f = Random.Finite(entropy);
```
> When the entropy used to create the instance of `f` is consumed. All methods called on `f` will return the `null` value.

We can simulate a coin toss, this will return 0 or 1 with equal probability and consumes 1 bit of entropy.
```motoko
let result = f.coin();
```
Combining all the methods we've seen, here is we how we would implement a canister that simulates `tossACoin`. 
```motoko
import Random "mo:base/Random"
actor {
    // Returns 0 or 1 with a 50% probability. Consumes 1 bit of entropy.
    public func tossACoin() : async ?Bool {
        let entropy = await Random.blob();
        var f = Random.Finite(entropy);
        return f.coin();
    };
};
```
We can randomly generate a number `?Nat8` in the range [0..255], this will consumes 1 byte of entropy.
```motoko
let number = f.byte();
```
## 🕣 Time
Another challenge that comes with a distributed system is the notion of time. Each node has it's own internal horloge. To respected determinisn, the time provided to the canister is the **system time** - a value agreed upon by the subnet. The **system time** is represented as nanoseconds since 1970-01-01, the time is constant within the same round. 

In Motoko, the type `Time` is defined as an `Int`.
```motoko
public type Time = Int;
```
The Time module gives us access to the `now()` function that returns the system time.
```motoko
import Time 
actor {
    public type Time = Time.Time;
    public func whatTimeIsIt() : async Time.Time {
        Time.now();
    };
};
```
[TODO : ADD CODE SAMPLE TO SHOW THAT THE TIME IS CONSTANT WITHIN A ROUND]
## ⏰ Timer
Sometimes you need to run tasks a on regular basic (every minute/hour/day...). To run cronic tasks, you can use the [Timer library](https://internetcomputer.org/docs/current/motoko/main/base/Timer). 

This library defines two types:
1. `Duration` represents a delay before executing the job. The delay provided can be as small as possible but the resolution cannot be faster than the block rate. 
```motoko
type Duration = {#seconds : Nat; #nanoseconds : Nat}
```
2. `TimerId` is an ID to identify the timer.
```motoko
type TimerId = Nat
```

This library exposes different methods:
- `setTimer` allows  you to set a `job` that will be executed once in the future after the given duration `d` has passed.
```motoko
func setTimer(d : Duration, job : () -> async ()) : TimerId
```
```motoko
let oneHourInSeconds = 60 * 60;
func endExam() : async () {
    // ...
};
let id = setTimer(#seconds(oneHourInSeconds), endExam);
```

- `recurringTimer` allows you to set a `job` that will be executed chronically everytime the given duration `d` has passed. 
```motoko
func recurringTimer(d : Duration, job : () -> async ()) : TimerId
```
```motoko
let oneDayInSeconds = 60 * 60 * 24;
func study() : async () {
    // ...
};
let studyId = reccuringTimer(#seconds(oneDayInSeconds), study);
```
- `cancelTimer` will cancel an active timer. If the `id` provided is not recognized nothing happens.
```motoko
let cancelTimer : TimerId -> ()
```
```motoko
func quitSchool() {
    cancelTimer(studyId);
};
```
### ⛽️ Cycles 
As we've seen before, cycles are used to pay for computation & storage on the IC. Cycles have a linear relation with the cost of executing WebAssembly instructions (one instruction consumes 0.4 cycles). Other actions that cost cycles include:
- Creating a new canister.
- Executing an update message (no matter the number of instruction)
- Cross-subnet calls
- Storing data 
- Creating a Threshold ECSDA signature.
- Realizing an HTTPS outcall. 

The cycle cost depends on the subnet the canister is running on. The more nodes in the subnet the higher the cost (linear relation).

Cycles can only be owned by canisters. The ownership of cycles can be transferred between actors by sending and receveing messages (i.e calling `shared function`). A caller can choose to transfer cycles with a call, and a callee can choose to accept cycles that are made available by the caller, this needs to be explicitly coded.

In Motoko, the [ExperimentalCycles library](https://internetcomputer.org/docs/current/motoko/main/base/ExperimentalCycles) allows you to manage cycles within actors.
> All libraries starting with the **Experimental** keyword are subjects to change in the future. Notably dedicated syntactic support for manipulating cycles might be added to the Motoko language in the future, rendering the **ExperimentalCycles** library useless.

We can access the balance of the canister using the `balance` value.
```motoko
import Cycles "mo:base/ExperimentalCycles";
actor {
    public func walletBalance() : async Nat {
        return(Cycles.balance());
    };
};
```
> You will notice that the value of your canister's current balance will change between 2 calls to `walletBalance`: the call itself consumes cycles & any canister deployed on the IC always consume cycles to pay for it's storage cost. 

It is possible to attach cycles to messages sent. For instance, using `dfx` 
```motoko
dfx canister call  <CANISTER_NAME> <METHOD_NAME> --with-cycles <WITH_CYCLES>
```
This command will attach the provided number of cycles to the message by picking from your cycle wallet.

We can access the `amount` of cycles attached to a call by using the `available` value. 

```motoko
import Cycles "mo:base/ExperimentalCycles";
actor Experiment {
    public func howMuchCyclesAreAttachedToThisCall() : async Nat {
        let available = Cycles.available(); 
        return available;
    };
};
```
On the other hand, we can attach cycles to the next call by using the `add` value.
```motoko
let add : (amount : Nat) -> ()
```
```motoko
import Cycles "mo:base/ExperimentalCycles";
actor Experiment {

    public func howMuchCyclesAreAttachedToThisCall() : async Nat {
        let available = Cycles.available(); 
        return available;
    };

    public func attachCycles(amount : Nat) : async Nat {
        Cycles.add(amount); // Add amount of cycles for the next call
        let attached = await howMuchCyclesAreAttachedToThisCall(); // In this message the cycles are attached
        return attached; // Return same than amount since we don't take any cycle from the message
    };
}
```
The call to `attachCycles` should return the `amount` provided since we don't take any cycles.

```bash
$ dfx canister call Experiment attachCycles '(100_000)'
(100_000 : nat)
```

> Due to security concerns, manipulating cycles is not something that is possible using the [Motoko Playground](https://m7sm4-2iaaa-aaaab-qabra-cai.ic0.app/). If you try the code shown earlier, all functions will resolve to 0.

We can take `amount` of cyles from the message by using the `accept` value. The amount returned `accepted` might be less than the `amount` requested if the message has less cycles available, or if the canister balance limits are reached.
```motoko
let accept : (amount : Nat) -> (accepted : Nat)
```
```motoko
import Cycles "mo:base/ExperimentalCycles";
actor Experiment {

    public func takeSomeCycles(amount : Nat) : async (Nat, Nat) {
        let accepted = Cycles.accept(amount);
        let remaining = Cycles.available();
        return(accepted, remaining);
    };

    public func giveAndTake(give : Nat, take : Nat) : async (Nat, Nat) {
        Cycles.add(give);
        let result = await takeSomeCycles(take);
        return result; 
    };
}
```
The call to `giveAndTake` should return a tuple of `Nat` where the sum equals the value provided for `give`.
```bash
$ dfx canister call Experiment giveAndTake '(1000, 100)'
(100 : nat, 900 : nat)
```
## 🧮 Binary operations
Motoko supports Bitwise operations (manipulation of the bits) through bounded integers (`Nat8`,`Nat16`, `Nat32`, `Nat64` & `Int8`,`Int16`, `Int32`, `Int64`).
- AND (Symbol `&`): This operation takes two binary values and performs a logical AND operation on each pair of corresponding bits. The result is a binary value where each bit is set to 1 only if the corresponding bits in both operands are set to 1.
```motoko
let a = 31 : Nat8;  // Binary 0011111
let b = 33  : Nat8; // Binary 0100001
let c = a & b (1)  // Binary 0000001 
assert(c == 1) // true
```
- OR (Symbol `|` ): This operation takes two binary values and performs a logical OR operation on each pair of corresponding bits. The result is a binary value where each bit is set to 1 if either or both corresponding bits in the operands are set to 1.
```motoko
let a = 31 : Nat8;  // Binary 0011111
let b = 33  : Nat8; // Binary 0100001
let c = a | b (63)  // Binary  0111111
```
- XOR (Symbol `^`): This operation takes two binary values and performs a logical XOR (exclusive OR) operation on each pair of corresponding bits. The result is a binary value where each bit is set to 1 if only one of the corresponding bits in the operands is set to 1.
```motoko
let a = 31 : Nat8;  // Binary 0011111
let b = 33  : Nat8; // Binary 0100001
let c = a ^ b (62)  // Binary  0111110
```
- Shift Left (Symbol `<<`): This operations moves the bits to the left by a specified number of positions, adding zeros to the right.
```motoko
let a = 64 : Nat8; //    binary 01000000
let c = a << 1 (128) //  binary 10000000 
```
- Shift right (Symbol `>>`): This operations moves the bits to the right by a specified number of positions, adding zeros to the left.
```motoko
let a = 64 : Nat8; //    binary  01000000
let c = a << 1 (32) //   binary  00100000
```
- Rotation left (Symbol `<<>`): This operations shifts the bits of a binary value to the left by a specified number of positions, and then rotating the shifted bits back to the right end of the value.
```motoko
let a = 128 : Nat8;     //  binary  1000000
a <<> 1 (1)             //  binary  0000001 
```
- Rotation right (Symbol `<>>`): This operations shifts the bits of a binary value to the right by a specified number of positions, and then rotates the shifted bits back to the left end of the value. 
```motoko
let a = 64 : Nat8;      // binary 001000000
a <>> 1 (32)            // binary 000100000
```

## ⚛️ Atomicity 
> Atomicity is a property of database transactions, which states that a transaction must be treated as a single, indivisible operation that is either completed in its entirety or not executed at all. This means that all of the changes made within a transaction must be committed to the database together, or none of them should be committed.

When a canister receives a message, the execution is atomic which means that other messages will be queued and processed later - the canister is focused on executing the code corresponding to the message. This is a really useful property that directly ensues from the [Actor model](https://en.wikipedia.org/wiki/Actor_model#:~:text=The%20actor%20model%20in%20computer,building%20block%20of%20concurrent%20computation.). It prevents race conditions, or unexpected state changes. <br/>

```motoko
actor Bank {

    var balance : Nat = 100;

    public query func checkBalance() : async Nat {
        return balance;
    };

    public func pay(amount : Nat) : async Nat {
        if(balance > amount){
            balance := balance - amount;
        };
        return balance;
    };

};
```

For instance, when calling `pay` we can be sure that no other message will modify the value of `balance` while the code is executing. However, as soon as the body of the function being executed contains an `await`, atomicity is not guaranteed anymore! <br/> Whenever a canister `await` it can process other messages during the waiting period before resuming the code where it stopped.
Let's imagine that we have a second actor `Restaurant`. This actor has the following flow: 
1. Check the balance of `account` by calling the `Bank` actor.
2. Prepare the sandwich 
3. Request the payment.
```motoko
actor Restaurant {

    let priceSandwich : Nat = 5;

    let bank : actor {
        checkBalance : () -> query nat; 
        pay : (amount : nat) -> async nat;
    };

    public func prepareSandwich() : async Text {
        return("🥪");
    };

    public func getSandwich() : async Text {
        let balance = await bank.checkBalance();
        if(balance >= priceSandwich) {
            let sandwich = await prepareSandwich();
            let remaining = await pay(5);
            return sandwich;
        } else {
            return ("Looks like you don't have enough funds!");
        }
    };
};
```
The code has a fundamental flaw because the `getSandwich` method is not atomic. This means that when the first check occurs, the account balance could be higher than `5`. However, between that check and the moment when the payment is actually made, the `Bank` actor may receive and process other messages that change the account `balance`. As a result, the payment may become impossible, even if it initially appeared that there were sufficient funds available.

> Non-atomicity, if not properly treated, introduces a lot of security issues. When dealing with such situations it is best to always assume that after any `await` the state of the canister could be completely different than initially!
## 💾 Commit point 
A **commit point** is a precise moment where the state changes made to the actor are commited and made visible to other actors or users. It usually corresponds to a specific line of code.

The moments where the state changes are commited are:
- Exit from a shared function by sending a result.
- Exit from a shared function via `return` or `throw` expressions.
- `await` expression.

An important thing to note is that `trap` will roll back all state changes until the latest commit point! 
```motoko
import Array "mo:base/Array";
import Error "mo:base/Error";
import Buffer "mo:base/Buffer";
actor Commit {
    var stateCommits = Buffer.Buffer<Text>(0);

    public query func seeCommits() : async [Text] {
        return Buffer.toArray(stateCommits);
    };

    public func commitReturn() : async () {
        stateCommits.add("commitReturn");
        return; // 💾 - commit point 
    };

    public func commitThrow() : async () {
        stateCommits.add("commitThrow");
        throw(Error.reject("An error occured")); // 💾 - commit point 
    };

    public func noCommitTrap() : async () {
        stateCommits.add("noCommitTrap");
        ignore 0/0; // 🙅‍♂️ trap - will roll back all state changes! 
    };

  public func commitNonAtomic() : async () {
    stateCommits.add("commitNonAtomic1");
    let f = commitReturn(); 
    stateCommits.add("commitNonAtomic2");
    await f; // this will commit state changes
    stateCommits.add("commitNonAtomic3");
    ignore 0/0; // 🙅‍♂️ trap - will roll back all state changes until the previous commit point! 
  };
};
```
If we call `atomicCommit`: the message is processed, and whenever the function exits by `return` the state changes are commited.
```motoko
$ dfx canister call Commit commitReturn
()
```
That means that if we call `seeCommits` just after we can see the message added to the `Buffer`.
```motoko
$ dfx canister call Commit seeCommits
(vec { "commitReturn" })
```
The same situation will happen with `commitThrow` but instead of a nice `return` we will receive an `error`.
```motoko
$  dfx canister call Commit commitThrow
Error: Failed update call.
Caused by: Failed update call.
The Replica returned an error: code 4, message: "An error occured"
```
But the state changes are still commited.
```motoko
$ dfx canister call Commit seeCommits
(vec { "commitReturn"; "commitThrow" })
```
However, the situation is completely different with `noCommitTrap`
```motoko
dfx canister call Commit noCommitTrap
Error: Failed update call.
Caused by: Failed update call.
The Replica returned an error: code 5, message: "Canister rrkah-fqaaa-aaaaa-aaaaq-cai trapped: integer division by 0"
```
We cannot see any state changes, indeed they have been rolled back because of the `trap`! 
```motoko
$ dfx canister call Commit seeCommits
(vec { "commitReturn"; "commitThrow" })
````
Earlier, we mentioned that changes to the state are not committed with a `trap`. However, this is only true until the latest commit point. When a non-atomic function with multiple `awaits` is used, a `trap` will only undo changes made since the last await. Any changes made before that point will have already been committed and cannot be undone. <br/>
We can see this behaviour in action by calling `commitNonAtomic` 
```motoko
$ dfx canister call Commit commitNonAtomic
Error: Failed update call.
Caused by: Failed update call.
The Replica returned an error: code 5, message: "Canister rrkah-fqaaa-aaaaa-aaaaq-cai trapped: integer division by 0"
```motoko
The state changes that happened between the entry point of the function and the `await` can still be visible after the `trap`.
$ dfx canister call Commit seeCommits
( vec { "commitReturn"; "commitThrow"; "commitNonAtomic1"; "commitNonAtomic2"; "commitReturn";},)
```

## 🆚  Principal vs Account Identifier
## 