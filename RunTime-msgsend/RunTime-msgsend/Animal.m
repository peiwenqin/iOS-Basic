//
//  Animal.m
//  RunTime-msgsend
//
//  Created by pei on 2020/3/16.
//  Copyright © 2020 peipei. All rights reserved.
//

#import "Animal.h"
#import "Cat.h"
//#import <objc/runtime.h>

@implementation Animal

- (void)eat
{
    NSLog(@"I can eat");
}

//1,父类实现子类的方法--cat调用，直接log出play方法
- (void)play
{
    NSLog(@"I can play!");
}


@end
