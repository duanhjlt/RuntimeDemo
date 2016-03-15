//
//  ADClass.h
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADClass : NSObject

- (void)printName;

@end

@interface ADClass (ADClassAddition)

@property(nonatomic, copy) NSString *name;

- (void)printName;

@end
