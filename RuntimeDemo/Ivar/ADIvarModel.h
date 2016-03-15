//
//  ADIvarModel.h
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADIvarModel : NSObject {
    NSString* _userName;
}

@end

@interface ADIvarModelDemo : NSObject

- (void)changeUserName:(NSString *)userName;

@end