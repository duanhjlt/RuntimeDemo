//
//  NSObject+FastJSON.h
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FastJSON)

+ (NSString*)keyForProperty:(NSString*)objKey;
+ (Class)classOfJsonObject:(NSString *)objKey;

- (instancetype)initWithJsonData:(nullable NSDictionary *)dicData;
- (nonnull id)packJsonData;
- (void)parseJsonData:(nullable NSDictionary *)dicData;

@end

@interface NSArray (FastJSON)

+ (NSArray *)arrayWithJsonData:(NSArray *)dataList objectClass:(nonnull Class)objClass;

- (NSArray *)packJsonData;

@end

@interface NSDictionary (FastJSON)

+ (NSDictionary *)dictionaryWithJsonData:(NSDictionary *)dataDic objectClass:(nonnull Class)objClass;
- (NSDictionary *)packJsonData;

@end

@interface NSNumber (FastJSON)

- (NSNumber *)packJsonData;

@end

@interface NSString (FastJSON)

- (NSString *)packJsonData;

@end

@interface NSData (FastJSON)

- (NSString *)packJsonData;

@end

NS_ASSUME_NONNULL_END
