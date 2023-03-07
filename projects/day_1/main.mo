import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
actor Calculator {
  var counter : Float = 0;

  public func add(x : Float) : async Float {
    counter += x;
    return counter;
  };

  // Subtract.
  public func sub(x : Float) : async Float {
    counter -= x;
    return counter;
  };

  // Multiply.
  public func mul(x :Float) : async Float {
    counter *= x;
    return counter;
  };

  // Divide.
  public func div(x :Float) : async ?Float {
    if (x == 0) {
      // 'null' encodes the division by zero error.
      return null;
    } else {
      counter /= x;
      return ?counter;
    };
  };

  public func reset() : async () {
    counter := 0;
  };

  public func power(x : Float) : async Float {
    counter := counter ** x;
    return counter;
  };

  public func sqrt() : async Float {
    return Float.sqrt(counter);
  };

  public func floor() : async Float {
    return Float.floor(counter);
  };

  public func max(n : Float) : async Float {
    counter := Float.max(counter, n);
    return counter;
  };

};
