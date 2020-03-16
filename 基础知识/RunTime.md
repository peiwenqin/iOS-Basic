##RunTime运行时 消息机制

####运行时是OC的一个基础的机制，一般的C是在编译阶段就会得到所有方法的执行，OC的特殊之处是在编译阶段只会确定向接收者发送消息，而接收者是否响应以及如何响应该消息则会到运行时才会确定；
**栗子：**给对象声明一个方法但是并没有实现该方法的时候，在编译阶段的调用不会直接报错，当然程序在没有进行到执行这个没有实现的方法时，也不会崩溃，只有到程序走到执行这个方法的时候，才会报一个unrecognzed selecor send to instance...异常，这就是运行时的一个表现

#####objc-msgsend的走向
* **消息发送**
   * 1、判断发送消息的target(对象/类)是否是nil，若为nil，会直接清理不会响应该消息，这也是为什么对一个nil对象发送消息不会崩溃的原因，若不为nil，继续：
	* 2、是否忽略该selector消息----？
	* 3、通过对象的isa指针找到该类结构体，从而先在方法缓存cache里面找，找不到则在方法列表中查找，依次到父类以及超级父类中查找找到就响应，直到NSObject为止，期间若找到对应方法的实现就会直接响应，并且不会再向上发送查找消息，若一直没有找到，继续
   * 4、调用-resolveInstanceMethod:(实例方法)/+resolveClassMethod:(类方法)，返回YES表名可以找到该方法的实现，返回NO表示并未找到实现，在这个方法中我们可以人为实现消息发送未找到的方法,即添加method，这样也就实现了动态的为一个类添加方法到方法列表中，（ps：实例方法在类中查找，类方法在元类中查找）
   
   ```
   // 第一个参数：给哪个类添加方法
   // 第二个参数：添加方法的方法编号
   // 第三个参数：添加方法的函数实现（函数地址）
   // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
   class_addMethod([self class], sel, (IMP)selectorName, "v@:@");
   
   ```
   
* **消息转发：** 
	* 1.转发给其他的对象(非self自身，若是自身会陷入死循环查找)去接收forwardingTargetForSelector，其实这个对象只是把消息转发给另一个能处理这个消息的对象，这一步是没法对消息响应和处理的，比如消息的参数和返回值。
	
	```
	- (id)forwardingTargetForSelector:(SEL)aSelector
	{
		if (aSelector == @selector(MethodL)){
		   return otherObject;
		}
		return [super forwardingTargetForSelector: aSelector];
	}
	
	或者直接替换类方法：重写以下方法
	+ (id)forwardingTargetForSelector:(SEL)aSelector
	{
		if (aSelector == @selector(MethodL)){
		   return NSClassFromString(@"className");
		}
		return [super forwardingTargetForSelector: aSelector];
	}
	 
	
	```
	至此，若能找到转发的对象则会转发消息进行处理，这些都是系统帮忙的转发，而我们需要做的的是提供可以处理该消息的对象，如果这一步仍然找不到响应的对象的实现， 就要启用**完整的消息转发机制**
	
	* 重写forwardingInvocation，自定义转发逻辑

	```
	- (void)forwardInvocation:(NSInvocation *)invocation 	{
	    if (otherObject responsToSelector:[invocation selector]) {
	    		[invocation invokeWithTarget:otherObject];
	    } else {
	    		[super forwardInvocation:invocation];
	    }
	}
	
	- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
   		if ([NSStringFromSelector(aSelector) isEqualToString:@"selectorName"]) {
       	 return [NSMethodSignature signatureWithObjCTypes:"v@:"];//
    	}
   		return [super methodSignatureForSelector:aSelector];
}
	
	```
	若是这写方法没有实现，或者返回的是nil，那么这个消息的传递失败，抛出异常
	
	
	由此可见，一个消息若是找不到实现的方法，它尽了多大的努力
	