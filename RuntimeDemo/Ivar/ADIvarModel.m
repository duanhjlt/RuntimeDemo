//
//  ADIvarModel.m
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import "ADIvarModel.h"
#import <objc/runtime.h>

@implementation ADIvarModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _userName = @"ADIvarModel";
    }
    return self;
}

@end

@implementation ADIvarModelDemo

- (void)changeUserName:(NSString *)userName {
    ADIvarModel *model = [ADIvarModel new];
    
    Ivar userNameIvar = class_getInstanceVariable([ADIvarModel class], "_userName");
    NSString *userName2 = object_getIvar(model, userNameIvar);
    NSLog(@"old username = %@", userName2);
    object_setIvar(model, userNameIvar, userName);
    userName2 = object_getIvar(model, userNameIvar);
    NSLog(@"new username = %@", userName2);
}

@end
