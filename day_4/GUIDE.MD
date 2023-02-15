# Day 4️⃣
- Intercanister call (basic)


## 👦 Identity 
### Username & passwords.
Identity is at the core of our digital lives. In the rapidly evolving world of the internet, it has become more important than ever to have secure and trustworthy methods of accessing our personal accounts and spaces. <br/>
For years, the traditional way of logging into websites has been with passwords & usernames. 

<p align="center"> <img src="./img/password_username.jpeg" width="400px" style="border: 2px solid black;"></p>
<p align="center"> You are probably familiar with that type of interface.</p>

To create effective and secure passwords, one should:

- Select a long and randomly generated password.
- Avoid using the same password across multiple websites.

However, even when respecting basic security rules, this method of login has fundamental issues:

1. The server that grants authentication must store the username and password combination to verify the login and grant access. Although the password is often stored as a  hash, data breaches and leaks are still common.

2. Remembering and keeping track of passwords is a challenge, as most people have multiple accounts on various platforms, making it difficult to recall all of them. This is why the use of password managers and logging in through big tech companies (Apple, Facebook, Google, Microsoft) has become more prevalent.

3. Using passwords on a decentralized infrastucture like the Internet Computer is a bad idea. We are evolving in a world where we assume that some nodes can be malicious. If we need to send the password to all nodes, then it might leak at this point. 
### Login with Big Tech
As a result, the use of password managers and logging in through big tech companies like Apple, Facebook, Google, or Microsoft has become more prevalent. However, this method of login has its drawbacks as well. It requires people to trust these big tech companies with their personal information and access to other websites.

[TODO : ADD LOGIN WITH BIG TECH ]

With the increasing number of information we put online, do we really want to trust a handful of private companies? 
### Digital signatures 
Digital signatures are a more secure alternative to traditional username and password authentication. Digital signatures use a cryptographic technique to verify the authenticity of a message or document, ensuring that it has not been tampered with and that it comes from a verified sender. They are widely used in electronic transactions, such as online banking and e-commerce, as they provide a higher level of security and protection against fraud.

As the Internet Computer is built on a lot of cryptography, you won't be surprised to learn that they are used as a authentication mechanism for messages.
A digital signature scheme relies on 3 algorithms: 

1. **Key generation**: This algorithm is used to generate a public key and a private key. The public key is used to verify the digital signature, while the private key is used to create the digital signature.

2. **Signature**: This algorithm is used to create the digital signature using the private key. It applies a mathematical formula to the data that needs to be signed and the private key to generate a unique digital signature.

3. **Verification**: This algorithm is used to verify the digital signature using the public key. It applies a mathematical formula to the signed data, the digital signature, and the public key. If the output of the formula matches the original data, the digital signature is considered valid and the data is considered authentic.

<p align="center"> <img src="./img/digital_signatures.png" width="800px" style="border: 2px solid black;"></p>

Of course, digital signatures have been already used intensively in the world of crypto! Everyone should know the famous saying: [Not your keys not your crypto](https://www.ledger.com/academy/not-your-keys-not-your-coins-why-it-matters). 
Users owning and mangaging their keys is great for security & decentralization, however it's not that easy. <br/> The main problem is keeping them secure & accessible.

<p align="center"> <img src="./img/lost_bitcoins.jpeg" width="800px" style="border: 2px solid black;"></p>
<p align="center"> If you loose your keys, there is no backup! </p>

If we want to manage our entire digital identities using cryptographic keys while onboarding millions of people into Web3, it seems that there is a challenging project to solve here! How do we keep the benefits of digital signatures while making it easier to use for everyone? 

### Web Authentication
[WebAuthentication](https://webauthn.guide/), also known as WebAuth, is a web standard that attempts to solve the issues raised earlier and standardize logins using public-key cryptography. 


- When a user first register to a WebAuthn-enabled service: 
    1. A key pair is generated for you. 
    2. The private key is stored securely on your device.
    3. The public key is sent to the service and associate it with the user's account.


[TODO : ADD ILLUSTRATION]


- When the same user wants to login again:
    1. A challenge is generated by the service.
    2. The device attemps to verify your identity through authentication factors (FaceID, TouchID, YubiKey, Windows Hello...)
    3. If the verification is correct, the device will sign the challenge and send it back to the service. 
    4. If the signature is correct, the service will grant access.

[TODO : ADD ILLUSTRATION]

The device usually integrates a secure chip that stores the private key. Those chips are designed to **never leak the private key**, they are only able to create signature when requested. 

WebAuthentication is both secure & convenient.

### Message on the Internet Computer.
As we mentionned on  day 1, all requests sent to the Internet Computer are passed through messages. Those messages are authenticated. 

[TODO : ADD ILLUSTRATION]

> There is an identity which is called the **Anonymous** identity, and allows communication with the Internet Computer in a completely anonymous manner.

A message contains the following information:
- ID of the target canister.
- Function called on this canister.
- Arguments provided for this functions. 

But more importantly, the message contains a signature! We can use this signature to verify the identity of the caller. 
### Delegations
With WebAuthentication, whenever the user creates a signature his identity will be verified through the authentication factors that've mentionned before, usually asking the user for confirmation. 
Let's imagine that our user wants to do the 3 following actions:

1. Log in into DSCVR.
2. Update his user profile.
3. Post a message.

Do we really want to verify the identity 3 times for all those actions? 
Since all messages are signed on the Internet Computer it would mean that we have to confirm our identity everytime that we interact with any canister! That would quickly be annoying. 

The solution? **Delegation**! 
A delegation is a short-term pair of keys, that we create when an user log in. This pair of keys is stored locally and can be used for performing any number of actions, during a specific timeframe. 
The document that grants delegation is signed by the master pair of keys.

## 🆔 Internet Identity
### Canister signature
Each subnet is able to create a signature that certifies a piece of data coming from the Internet Computer. A canister can request the subnet it is hosted in to create a signature on a specific data; this mechanism is called [certified variables](https://internetcomputer.org/how-it-works/response-certification/).

Building upon this mechanism, canisters are able to create signatures.
> If you want to know more about certified variables, check out this video & this repository.
[TODO: ADD MORE IMAGE OR TEXT]

Making use of WebAuthn, delegations & canister signatures, DFINITY has designed a Web3 identity solution called Internet Identity.<br/>
Internet Identity allows users to create sessions with Web3 services and dapps, and sign traditional blockchain transactions.
### How does Internet Identity work?
Internet Identity is a canister that manages your pair of keys and allows you to create short-term delegations for log in into other canisters. It does not store the private keys are those are securely stored on your device(s). 
Whenever you try to log in to a service through Internet Identity: a session key pair will be created on your device and stored locally, then once you've confirmed the log in you'll request the Internet Identity to create a signature and grant a delegation to your short 

1. Creation of an anchor: this is your identity to which you'll be able to add devices. 

2. Registration of device(s) to your anchor.
- You can register multiple devices to your identity. All registered devices have access to your identity.
- You need to have at least one registered device at any time - otherwise you'll not be able to access your identity and you'll have to use one the backup mechanisms that you've (hopefully) put in place.
- You can remove registered devices whenever you need. 

3. Connect to a dApp
    1. You are visiting your favorite application and want to log in using Internet Identity.
    2. Your identity is verified (Biometric authentication / USB security keys)
    3. A local short-term key pair is created.
    4. A **signed** message from your master key pair is sent to the Internet Identity canister, asking the canister to create a delegation for your local key pair.
    5. The delegation is sent back to your device and stored.
    6. You can now use the application with your local key pair and send along the delegation. You don't have to request a signature using WebAuthn for each message that you send.


[TODO : ADD ILLUSTRATIONS]

### Principal
A principal is a public identifier used on the Internet to identify entities that can interact with the Internet Computer. These entities are either users or canisters. We distinguish different types of principals

- **Self-authenticating ids** (User): for an user, a principal is directly derived from it's public key. For instance, you can read the principal of your `dfx` identity. These Principals are 29 bytes long.

```motoko
$ dfx identity get-principal
2ujkt-fujau-bunuv-gt4b6-2s27j-cv5qi-kddkp-jl7m4-wdj3e-bqdrt-qqe
```

- **Opaque ids** (Canister): for a canister, the principal is the canister ID. The ID is automatically determined when the canister is created based on the subnet the canister is in and the number of canisters already deployed.

- **Anonymous id** (Anonymous): is the default caller used when an unauthenticated user calls functions. For instance, if you need to present information from a canister on a webpage before the user logs in, you would call functions to fetch the information, and your canister would recognize the caller as the Anonymous id because the user's Principal is unknown until they log in.

> There actually exist [two other types of principals](https://internetcomputer.org/docs/current/references/ic-interface-spec#id-classes) which you will never encounter. Those are used internally by the protocol or reserved for future potential usages. 

Principals in Motoko are a primitive type called `Principal`. 


### Getting a user principal
Within your actor, you can access the principal of the person calling your function by adding the `shared (message)` syntax. This keyword needs to be placed immediately before the `func` keyword and after the `public` keyword. This allows you the inspect the message. 
The message as a property `caller` that you can access by using `message.caller`. This property corresponds to the principal of the entity (user or canister) calling the function.

> Message is a special object that is available to all `public shared functions`. As of today, it is only used for accessing the `caller` property but it might have other use cases in the future.

```motoko
actor {

    public shared (message) func returnCallerPrincipal() : async Principal {
        let p = message.caller;
        return p;
    };
};
```
Principals have a textual representation. We can convert a `Principal` to his textual representation by using `Principal.toText()` from the [Principal module](https://internetcomputer.org/docs/current/motoko/main/base/Principal). Alternatively, we can get a `Principal` from his textual representation by using `Principal.fromText()`.

```motoko
let p : Principal = message.caller;
let textualRepresentation : Text = Principal.toText(p); // => "un4fu-tqaaa-aaaab-qadjq-cai"
let standardRepresentation : Principal = Principal.fromText(textualRepresentation); 
```

It can be useful to know if the caller is authenticated or not. There is dedicated function `Principal.isAnonymous` that returns a `Bool` indicating if the user is anonymous or not. 
```motoko
let p : Principal = message.caller;
let isAnonymous : Bool = Principal.isAnonymous(p);
if(isAnonymous){
    return ("Sorry only authenticated users can access this app!");
};
```
> The textual representation of the anonymous principal is `2vxsx-fae`. Make sure to remember it as you will often come accross it.

One last tip! We can use object destructuring to directly access the caller on a message - that allows for a shorter syntax. 
```motoko
actor {

    public shared ({ caller }) func returnCallerPrincipal() : async Principal {
        return caller;
    };
};
```
### Cross-dApp communication
When a user registers into a new application using Internet Identity a new identity for this app is generated. The identity is a self-authenticating id. One of the parameter that is used to randomly determines the principal id is the frontend host (i.e what is the domain that the user is connecting from). This means that if you are connecting on different services over Internet Identity, those services will authenticate you with a different id. This is extremly important to avoid tracking users across applications and increase privacy! 

The downside of this approach is that it makes developing cross applications features more complicated. 
Let's imagine the following scenario:
1. You are connecting on DSCVR using Internet Identity. DSCVR knows you as: `2ujkt-fujau-bunuv-gt4b6-2s27j-cv5qi-kddkp-jl7m4-wdj3e-bqdrt-qqe`. 

2. You want to join the [Motoko Bootcamp portal](https://dscvr.one/p/motoko-bootcamp). The access to this portal is reserved to user that graduated from the Bootcamp and own one Motoko Bootcamp diploma.

3. You own a Motoko Bootcamp diploma, this diploma is an NFT that is stored in another canister. This canister knows you as `nfxu4-cn7qt-x7r3c-5dhnk-dcrct-gmgoz-67gcg-5glvc-2krhv-gcmsr-qqe`.

How does DSCVR determine that you have a diploma and allow you access to the portal? By default, Internet Identity does not support this feature. However, there are several solutions available:

1. One solution is to provide DSCVR with information about your identity on the Motoko Bootcamp canister, enabling it to verify that you possess the diploma. This solution works, but it also exposes your complete identity, which may not be ideal.

2. The other solution would be to change the authentication mechanism on both dApps. Some identity solutions use the same identity accross all dApps on the Internet Computer. This solution also works, but is far from ideal since you are losing all your privacy and can easily be tracked.

3. Implement a protocol allowing for attribute sharing between the two canisters. This protocol would allow the Motoko Bootcamp canister to issue a credential proving that the user possess a diploma without having to reveal his identity. 

> This last solution is currrently the focus of several projects on the Internet Computer. [The protocol](https://github.com/dfinity/wg-identity-authentication/blob/main/topics/attribute-sharing.md) allowing for sharing of credentials is [being discussed and designed by the Identity & Authentication Working Group](https://forum.dfinity.org/t/technical-working-group-identity-authentication/). 

## Datastructures
### HashMap & TrieMap 
In Motoko, [HashMap](https://internetcomputer.org/docs/current/references/motoko-ref/HashMap) and [TrieMap](https://internetcomputer.org/docs/current/references/motoko-ref/HashMap) are both implemented as a Class and have the same interface. The only difference is that `TrieMap` is represented internaly by a `Trie` while `HashMap` is using `AssocList`. All examples that will follow use `HashMap` but it would be similar for `TrieMap`. 

- K is the type of the key (`Nat`, `Text`, `Principal`...)
- V is type of the value that will be stored (User data, Token balance...)

```motoko
class HashMap<K, V>(initCapacity : Nat, keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash)
```

To instantiate a value from the class, we need to provide:
1. An initial capacity of type `Nat`.
    ```motoko
    initCapacity : Nat
    ```
2. A function that can be used for testing equality of the keys.
    ```motoko
    keyEq : (K, K) -> Bool
    ```
3. A function that can be used for hashing the keys.
    ```motoko
    keyHash : K -> Hash.Hash
    ```

Let's imagine that we want to store a `Student` associated with his `Principal`. Where `Student` is defined as
```motoko
type Student = {
    name : Text;
    age : Nat;
    favoriteLanguage : Text;
    graduate : Bool;
};
```

In that case:
- K is of type `Principal` and represents the key of the HashMap.
- V is of type `User` and represents the stored value. 

To initiate our `HashMap`
```motoko
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
actor {
    type Student = {
        name : Text;
        age : Nat;
        favoriteLanguage : Text;
        graduate : Bool;
    };

    let map = HashMap.HashMap<Principal, Student>(1, Principal.equal, Principal.hash);
}
```
To add a new entry to the `map` we can use the `.put()` method.
```motoko
map.put(principal, student);
```
This will insert the value `student` with key `principal` and overwrites any previous value. We can use this method to create a `register` function that students would need to call and provide all their relevant informations.

```motoko
public shared ({ caller }) func register(name : Text, age : Nat, favoriteLanguage : Text) : async () {
    if(Principal.isAnonymous(caller)){
        // We don't want to register the anonymous identity
        return;
    };
    let student : Student = {
        name;
        age;
        favoriteLanguage;
        graduate = false;  
    };
    map.put(caller, student);
};
```

Once a value has been inserted in the `map`, we can access it using the `.get()` method.
```motoko
map.get(principal);
```
This will return an optional value `?Student` associated with the provided principal. We can use this method to create a `getStudent` `query` function that would return information on students.
```motoko
public query func getStudent(p : Principal) : async ?Student {
map.get(p);
};
```
We can delete a value from the `map` by using the `.delete()` or `remove()` methods.
```motoko
map.delete(principal);   // Delete but doesn't return the value
let oldValue = map.remove(principal);   // Delete but returns the value
```
It is possible to iterate over the map:
- You can iterate over the keys with `.keys()`.
- You can iterate over the values with `.vals()`.
- You can iterate over both with `.entries()`.

### RBTree
[TODO : Section]
### Trie
[TODO : Section]
## ♻️ Upgrades.
Upgrading a canister is a common task.
There are a few things to consider before doing so:

- Could the upgrade cause data loss?
- Could the upgrade break the dApp due to interface changes?

### Stable memory vs Heap Memory
A canister has access to two types of memories: 
1. A wasm heap which is constrained to 4 GiB because currently the runtime of canisters [wasmtime](https://github.com/bytecodealliance/wasmtime) has only 32 bit addressing. This limit will be increased when [wasm64](https://github.com/WebAssembly/memory64) is supported by the runtime. The heap is a “pile" of memory, it is space available to the canister to allocate and de-allocate as needed. The heap is wiped during upgrades. The heap is the fastest memory available to the canister.

2. A [stable memory](https://internetcomputer.org/docs/current/references/ic-interface-spec#system-api-stable-memory) that can currently store up to 48GiB of storage. Everything in stable memory will survive upgrades. Accessing data in stable memory is slower compared to accessing memory in the heap because stable memory is not directly accessible within the runtime environment. Instead, accessing stable memory requires calling an external API.

> Developers who are new to the IC often ask the question: which memory should I use? Unfortunately, there is no one-size-fits-all answer to this question. The optimal choice depends on the requirements of your application (safety during upgrade over performances) and the amount of memory you'll need. If you are interested, [read & join the discussion over this topic that is constantly evolving](https://forum.dfinity.org/t/motoko-stable-memory-in-2022/10433). 

### Stable variables 
When a canister is upgraded, the state is lost by default. This means all data application data will be lost, unless it's handled to persist when the canister is upgraded. <br/>
This can be achieved by storing the data in stable variables, which will persist upgrades. To declare a variable as stable we use the `stable` keyword.
```motoko
stable var m : Int = 0;
```
The value of `m` will persits upgrades and not be lost. 
A stable variable is stored in the stable memory.

### Stable types
Unfortunately, not all variables can be declared as stables. 
```motoko
stable let map = HashMap.HashMap<Principal, Student>(1, Principal.equal, Principal.hash);
```
If we try with the `HashMap` type that we've seen earlier we will encounter an error: `variable map is declared stable but has non-stable type`. 

All primitives types are stable:
- `Nat` 
- `Text`
- `Ìnt`
- All bounded numbers: `Nat8`, `Nat16`, `Nat32`, `Nat64`, `Int8`, `Int16`, `Int32`, `Int64`.
- `Float`
- `Char`
- `Bool`
- `Array`

An object that contains methods (i.e a Class) cannot be stable. That's why `HashMap` & `TrieMap` cannot be declared as stable structures.

> It is possible to rewrite some libraries to convert them to stable types. For instance, [StableBuffer](https://github.com/canscale/StableBuffer) is a remake of the `Buffer` type allowing it to be called stable. 

### Interface changes
Another challenge when upgrading a canister in a distributed environment like the Internet Computer is that other canisters might be relying on the interface of the canister being upgraded.

Let's imagine that we have two canisters:
1. Canister A is the canister that we want to upgrade. It contains many public functions but we will just focus on `getDiploma`.
```motoko
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
actor School {

    type Diploma = {
        delivery_time : Time.Time;
        teacher : Principal;
        promotion : Nat;
    };

    let diplomas = HashMap.HashMap<Principal, HashMap>(0, Principal.equal, Principal.hash);

    public func getDiploma(p : Principal) : async ?Diploma {
        return diplomas.get(p);
    };

};
```

2. Canister B is the client canister that is relying on the interface of Canister A. We have to imagine that somewhere in the code of Canister B the `getDiploma` function of Canister A is called.
[TODO : Change canister ID];
```motoko
actor dApp {
    type Diploma = {
        delivery_time : Time.Time;
        teacher : Principal;
        promotion : Nat;
    };

    // We define the other canister in the code here.
    let schoolActor : actor {
        getDiploma(p : Principal) -> async ?Diploma;
    } =  actor("3db6u-aiaaa-aaaah-qbjbq-cai"); 

    public func shared ({ caller }) isAuthorized() :  async Bool {
        let answer = await schoolActor.getDiploma(caller);
        switch(answer){
            case(null){
                return false;
            };
            case(? some){
                return true;
            };
        };
    };
};
```
Suppose we're upgrading canister A and we decide to remove the `getDiploma` function. If we do that, it will cause problems for canister B because it relies on that function. But it's not just removing the function that could cause issues. If we modify the function's signature to something like this:

```motoko
getDiploma(p : Principal) -> async Result.Result<Diploma, Text>;
```
That change alone would also break canister B's code.
Whenever a canister on the IC is upgraded, it causes a risk to all relying canisters, and has we've said before composing services (i.e canisters) is a central piece of the vision of the Internet Computer - so we have to find a way to not break things! <br/>

That's where the magic of **Candid** comes into play! <br/> 
Candid defines a formalism and precise rules to make sure that any modification of the interface (adding new methods, changing function signatures, expecting additional arguments...) doesn't break existing clients.

For instance, evolving the signature of the `getDiploma` function from 
```motoko
getDiploma(p : Principal) -> async ?Diploma;
```
to
```motoko
getDiploma(p : Principal, bootcampYear: ?Nat) -> async ?Diploma;
```
Would not cause an issue, when reading messages from old clients, who do not pass that argument, a `null` value is assumed.

> In the following, all types and interfaces are exprimed in Candid format.

Let's look at more examples of what can and can't be done. Imagine the following service
```
service counter : {
  add : (nat) -> ();
  subtract : (nat) -> ();
  get : () -> (int) query;
}
```
The function `add` could evolve from 
```
add : (nat) -> ();
```
to 
```
add : (int) -> ();
```
This is possible because every `nat` is also an `int`. If a client provides a `Nat` it will be compatible with the new expected type. We say that `int` is a supertype of `nat`. However evolving the other way wouldn't be possible since all `int` are not `nat`. 

Additionally the function `add` and `substract` could evolve from
```
add : (nat) -> ();
subtract : (nat) -> ();
```
to 
```
add : (nat) -> (new_val : nat);
subtract : (nat) -> (new_val : nat);
```
This is possible because any new returned value that is not expected by old clients will simply be ignored. However, adding new (non-optional) parameters wouldn't be possible. 

To safely upgrade a canister, follow those rules:
- New methods can freely be added. 
- Existing methods can return additional values. Old clients will simply ignore additional values.
- Existing methods can shorten their parameter list. Old clients will send the extra argument(s) but they will be ignored.
- Exisiting methods can only add optional types as new parameters (type `opt`). When reading messages from old clients, who do not pass that argument, a `null` value is assumed.
- Existing parameter types may be changed, but only to a `supertype` of the previous type. For instance a `nat` parameter can be changed to a `int`. 
- Existing result types may be changed, but only to a `subtype` of the previous type. For instance an `int` result can be changed to a `nat`. 

> If you want more information on Candid, supertypes and subtypes, check the [reference guide](https://internetcomputer.org/docs/current/references/candid-ref).

### Data structure changes
Another example of how data can be lost, is by changing the data types. 

```motoko
stable var state : Int
```
In this example the variable `state` is `Int`, but let's imagine that during an update the type is changed to `Text`
```motoko
stable var state : Text
```
In this case the the current `Int` value will be lost. One way to avoid the data loss when changing the data types is to keep the original variable, and create a new variable for the new data type. This way the original data will not be lost due to canister upgrades.
### Stable type signature
The list of all stable variables of an actor is called the **stable signature**. The textual representation of the **stable signature** looks similar to an actor declaration.
```motoko
actor {
  stable x : Nat;
  stable var y : Int;
  stable z : [var Nat];
};
```
> The stable signature of an actor can be generated using the Motoko compiler: [moc](https://internetcomputer.org/docs/current/motoko/main/compiler-ref).

The stable signature is used to automatically check type compability before an upgrade. This is possible by comparing the signature of the new actor with the old one and using some rules based on Candid. For more information, see the [reference section on stable signatures](https://internetcomputer.org/docs/current/motoko/main/upgrades#stable-type-signatures).
### Metadata section
The Motoko compiler embeds the **Candid interface** and **stable signature** of a canister as canister metadata, recorded in additional Wasm custom sections of a compiled binary.

This metadata can be selectively exposed by the IC and used by tools such as `dfx` to verify upgrade.
```
$ dfx canister metadata [OPTIONS] <CANISTER_NAME> <METADATA_NAME>
```
###  Verifying upgrade compatibility
When you upgrade a canister, `dfx` will automatically download the metadata of the old module and compare it with the new module:
- Compare the Candid interface to make sure there is no breaking change.
- Compare the stable signatures to make sure there won't be data loss.

If you are making a breaking change you will receive a warning. 

<p align="center"> <img src="./img/candid_warning.png" width="800px" style="border: 2px solid black;"></p>
<p align="center"> The type of warning you will encounter. </p>

This verification doesn't guarantee that the upgrade will go through. A problem can still happen during the upgrade process. However, it does guarantee that if the upgrade goes through you won't break existing cliens or lose data that was marked as `stable`. 