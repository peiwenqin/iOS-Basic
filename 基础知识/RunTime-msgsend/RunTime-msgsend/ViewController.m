//
//  ViewController.m
//  RunTime-msgsend
//
//  Created by 王俊 on 2020/3/16.
//  Copyright © 2020 peipei. All rights reserved.
//

#import "ViewController.h"
#import "Cat.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Cat *cat = [Cat new];
    [cat performSelector:@selector(play)];//对象方法
//    [Cat performSelector:@selector(play)];//类方法
    
//    NSMethodSignature *signature = [ViewController instanceMethodForSelector:@selector(play)];
    
}


@end
