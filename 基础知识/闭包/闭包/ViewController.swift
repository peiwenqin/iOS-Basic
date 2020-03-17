//
//  ViewController.swift
//  闭包
//
//  Created by 王俊 on 2020/3/17.
//  Copyright © 2020 peipei. All rights reserved.
//

import UIKit

/*
 逃逸闭包其实类似我们在 cell 的 event 点击回调
 */
//1>
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

//2>
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
 
class SomeClass {
    var x = 10
    func doSomething() {
        //3>
        someFunctionWithEscapingClosure { self.x = 100 }
        //4>
        someFunctionWithNonescapingClosure { x = 200 }
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.test()
        
        let n = self.makeIncrementer(forIncrement: 5)
        print("---\(n())+\(n())+\(n())")
        
        let instance = SomeClass()
        instance.doSomething()
        print(instance.x)
        // Prints "200"
         
        
        //逃逸闭包----回调
        //这个是 200 的原因是这个是回调函数,相当于在 1>声明,4>实现,这里其实是在调用
        completionHandlers.first?()
        print(instance.x)
        // Prints "100"
    }
    

    //捕获----理解其实将捕获的参数变成了对于该函数而言的全局变量,不会被释放掉,除非这个方法被释放了
    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementer() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementer
    }
    
    //自动闭包是一种自动创建的用来把作为实际参数传递给函数的表达式打包的闭包。它不接受任何实际参数，并且当它被调用时，它会返回内部打包的表达式的值。这个语法的好处在于通过写普通表达式代替显式闭包而使你省略包围函数形式参数的括号。----讲真,这句话真的绕...我理解的就是直接用@autoclosure替换了一个大括号,大括号表示的是在一个闭包的实现
    //注意,自动闭包最好不要滥用,-----很容易导致代码逻辑混淆




    func test()  {
        /*
         简易测试闭包的语法结构和写法
         {(paramas) -> (return type) in
            //操作
         }
         */
        
        //1,正常
        let names = ["Chris","Alex","Ewa","Barry","Daniella"]
        let names1 = names.sorted(by: forward(s1:s2:))
        print("1----\(names1)")
        
        //2,初级简化
        let names2 = names.sorted { (s1: String, s2: String) -> Bool in return s1 > s2}
        print("2----\(names2)")

        //3,再简化-根据语境可以推断出参数类型以及返回类型
        let names3 = names.sorted(by:{ s1, s2 in return s1 > s2})
        print("3----\(names3)")
        
        //4,简化,直接省略 return,隐式返回
        let names4 = names.sorted(by: {s1, s2 in s1 > s2})
        print("4----\(names4)")

        //5,骨灰简化
        let names5 = names.sorted(by: >)
        print("5----\(names5)")
        
        //6,简写参数 $0,$1,$2...表示参数,需要从0开始
        let names6 = names.sorted(by: { $0 > $1})
        print("6----\(names6)")
        
        //7,尾随闭包---大括号写在小括号外面---便于多行数据操作时候的代码表达,更加直观
        //若闭包作为函数的唯一参数,又写成了尾随闭包,小括号可以去掉
        let names7 = names.sorted(){ $0 > $1}  //names.sorted{ $0 > $1}
        print("7----\(names7)")
    }
    
    func forward(s1: String, s2: String) -> Bool {
        return s1 > s2
    }
    
}

