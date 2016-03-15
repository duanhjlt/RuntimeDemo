//
//  ADClass.m
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import "ADClass.h"
#import <objc/runtime.h>

@implementation ADClass

- (void)printName {
    NSLog(@"%@\n",@"MyClass");
}

@end

@implementation ADClass (ADClassAddition)

+ (void)load {
    NSLog(@"%@",@"load in MyAddition");
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, "name", name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, "name");
}

- (void)printName {
    if (self.name.length > 0) {
        NSLog(@"%@",self.name);
    } else {
        NSLog(@"%@",@"MyAddition");
    }
}

@end
