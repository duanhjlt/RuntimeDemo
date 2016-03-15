//
//  ADPropertyDemo.m
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import "ADPropertyDemo.h"
#import <objc/runtime.h>

@implementation ADPerson

- (NSArray *)allProperties {
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertyArray = [[NSMutableArray alloc]initWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        [propertyArray addObject:name];
    }

    free(properties);
    
    return propertyArray;
}

- (NSDictionary *)allPropertyNamesAndValues {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        const char *propertyName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        id propertyValue = [self valueForKey:name];
        if (propertyName && propertyValue) {
            [dic setValue:propertyValue forKey:name];
        }
    }
    
    free(properties);
    
    return dic;
}

- (void)allMethods {
    unsigned int count = 0;
    Method *methods = class_copyMethodList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        
        SEL methodSEL = method_getName(method);
        const char *name = sel_getName(methodSEL);
        NSString *methodName = [NSString stringWithUTF8String:name];
        
        int argumentCount = method_getNumberOfArguments(method);
        NSLog(@"方法名：%@, 参数个数：%d", methodName, argumentCount);
    }
}

- (NSArray *)allMemberVariables {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        
        const char *name = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:name];
        [array addObject:ivarName];
    }
    
    free(ivars);
    
    return array;
}

@end

@implementation ADPropertyDemo

- (void)test {
    ADPerson *p = [[ADPerson alloc] init];
    p.name = @"Lili";
    
    size_t size = class_getInstanceSize(p.class);
    NSLog(@"size=%ld", size);
    
    for (NSString *propertyName in p.allProperties) {
        NSLog(@"%@", propertyName);
    }
}

@end
