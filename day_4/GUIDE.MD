# Day 4️⃣

- Stable memory, stable variables & upgrades.
- DataStructures: HashMap & TrieMap.
- Principal & Authentication on the Internet Computer (Overview of Internet Identity)

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

The device usually integrates a secure chip that stores the private key. Those chips are designed to **never leak the private key**, they are only able to create signature when requested. This makes for a really secure and easy system for users.


### 🆔 Internet Identity
### NFID
