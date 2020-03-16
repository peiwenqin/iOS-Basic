//
//  Cat.m
//  RunTime-msgsend
//
//  Created by pei on 2020/3/16.
//  Copyright © 2020 peipei. All rights reserved.
//

#import "Cat.h"
#import <objc/runtime.h>
#import "OtherObject.h"

@implementation Cat

//- (void)play
//{
//    NSLog(@"I can play!");
//}

void catPlay(id self,SEL selector) {
    NSLog(@"cat play!");
}



//2,直接添加该方法的实现,转到另一个方法中,可替换,增加
//+ (BOOL)resolveInstanceMethod:(SEL)selector
//{
//    if ([NSStringFromSelector(selector) isEqualToString:@"play"]) {
//        class_addMethod([self class], selector, (IMP)catPlay, "v@:@");
//        return YES;
//    }
//    return [super respondsToSelector:selector];
//}



//3,消息转发---直接找到其他的对象实现方法,系统帮忙转发该消息
//- (id)forwardingTargetForSelector:(SEL)sel{
//    if (sel == @selector(play)) {
//        return [OtherObject new];
//    }
//    return [super forwardingTargetForSelector:sel];
//}

//+ (id)forwardingTargetForSelector:(SEL)sel{
//    if (sel == @selector(play)) {
//        return NSClassFromString(@"OtherObject");
//    }
//    return [super forwardingTargetForSelector:sel];
//}



//4,完整转发,自定义转发---可以自定义加参数和返回值
- (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"play"]) {
           return [NSMethodSignature signatureWithObjCTypes:"v@:"];
       }
       return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    OtherObject *objc = [OtherObject new];
    [anInvocation setSelector:@selector(play)];
    [anInvocation invokeWithTarget:objc];
}

//- (void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    if ([OtherObject respondsToSelector:[anInvocation selector]]) {
//        [anInvocation forwardInvocation:anInvocation];
//    } else {
//        [super forwardInvocation:anInvocation];
//    }
//}


@end
