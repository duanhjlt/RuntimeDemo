//
//  ViewController.m
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import "ViewController.h"
#import "ADClass.h"
#import "ADIvarModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ADClass *test = [[ADClass alloc]init];
    
    /**
     *  方法重名时，category优先级要高
     */
    [test printName];
    
    /**
     *  category添加属性
     */
    test.name = @"alexander";
    [test printName];
    
    ADIvarModelDemo *demo = [ADIvarModelDemo new];
    [demo changeUserName:@"alxeander"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
