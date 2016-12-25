//: Playground - noun: a place where people can play

import UIKit

class Test {
    var completion: ((_ name: String?) -> Void)?
    
    func doStuff() {
        completion = { (name) in
            if let n = name {
                print(n)
            } else {
                print("nil")
            }
        }
    }
}

class Person {
    var t = Test()
    var name: String? = nil
    
    func revealName() {
        t.completion!(name)
    }
}



let t = Test()
let p = Person()
p.t = t
t.doStuff()
p.revealName()