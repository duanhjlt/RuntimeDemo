//
//  UIControl+ADBlock.h
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ADTouchUpBlock)(id sender);

@interface UIControl (ADBlock)

@property (copy, nonatomic) ADTouchUpBlock block;

@end
