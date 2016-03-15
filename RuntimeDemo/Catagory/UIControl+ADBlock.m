//
//  UIControl+ADBlock.m
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import "UIControl+ADBlock.h"
#import <objc/runtime.h>

@implementation UIControl (ADBlock)

- (void)setBlock:(ADTouchUpBlock)block {
    objc_setAssociatedObject(self, "ADBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self removeTarget:self action:@selector(adOnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    if (block) {
        [self addTarget:self action:@selector(adOnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (ADTouchUpBlock)block {
    return objc_getAssociatedObject(self, "ADBlock");
}

- (void)adOnTouchUp:(id)sender {
    ADTouchUpBlock touchUp = self.block;
    
    if (touchUp) {
        touchUp(sender);
    }
}

@end
