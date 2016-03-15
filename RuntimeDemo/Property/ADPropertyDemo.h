//
//  ADPropertyDemo.h
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *array;

- (NSArray *)allProperties;
- (NSDictionary *)allPropertyNamesAndValues;
- (void)allMethods;
- (NSArray *)allMemberVariables;

@end

@interface ADPropertyDemo : NSObject

- (void)test;

@end
