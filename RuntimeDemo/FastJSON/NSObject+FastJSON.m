//
//  NSObject+FastJSON.m
//  RuntimeDemo
//
//  Created by duanhongjin on 16/3/15.
//  Copyright © 2016年 lanxin. All rights reserved.
//

#import "NSObject+FastJSON.h"
#import <objc/runtime.h>

@implementation NSObject (FastJSON)

+ (NSString*)keyForProperty:(NSString*)objKey {
    return objKey;
}

+ (Class)classOfJsonObject:(NSString *)objKey {
    return nil;
}

- (instancetype)initWithJsonData:(nullable NSDictionary *)dicData {
    self = [self init];
    if (self) {
        [self parseJsonData:dicData];
    }
    return self;
}


- (nonnull id)packJsonData {
    NSMutableDictionary *propertyData = [NSMutableDictionary new];
    Class selfClass = [self class];
    while (selfClass != [NSObject class]) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        
        for (unsigned int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            
            const char *name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            NSString *key = [selfClass keyForProperty:propertyName];
            if (key.length > 0) {
                id propertyValue = [self valueForKey:propertyName];
                if (propertyValue) {
                    [propertyData setObject:[propertyValue packJsonData] forKey:key];
                }
            }
        }
        free(properties);
        selfClass = [selfClass superclass];
    }
    
    return propertyData;
}

- (void)parseJsonData:(nullable NSDictionary *)dicData {
    for (NSString *key in dicData) {
        objc_property_t property = class_getProperty([self class], [key UTF8String]);
        if (!property) {
            continue;
        }
        
        id data = [dicData objectForKey:key];
        if ([data isKindOfClass:[NSNumber class]]) {
            [self setValue:data forKey:key];
        } else if ([data isKindOfClass:[NSString class]]) {
            char *value = property_copyAttributeValue(property, "T");
            NSString *typeValue = [NSString stringWithUTF8String:value];
            free(value);
            
            NSRange range = [typeValue rangeOfString:@"NSData"];
            if (range.length) {
                NSData *original = [[NSData alloc]initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [self setValue:original forKey:key];
            } else {
                [self setValue:data forKey:key];
            }
        } else if ([dicData isKindOfClass:[NSArray class]]) {
            Class subClass = [[self class]classOfJsonObject:key];
            if (subClass) {
                NSArray *array = [NSArray arrayWithJsonData:data objectClass:subClass];
                [self setValue:array forKey:key];
            } else {
                [self setValue:data forKey:key];
            }
        } else if ([dicData isKindOfClass:[NSDictionary class]]) {
            Class objClass = nil;
            char *value = property_copyAttributeValue(property, "T");
            NSString *typeValue = [NSString stringWithUTF8String:value];
            free(value);
            
            if ([typeValue characterAtIndex:0] == '@' && typeValue.length > 3) {
                NSString *className = [typeValue substringWithRange:NSMakeRange(2, typeValue.length - 3)];
                objClass = NSClassFromString(className);
            }
            if ([objClass isSubclassOfClass:[NSDictionary class]]) {
                Class subObjClass = [[self class]classOfJsonObject:key];
                if (subObjClass) {
                    NSDictionary *objectDic = [NSDictionary dictionaryWithJsonData:data objectClass:subObjClass];
                    [self setValue:objectDic forKey:key];
                } else {
                    [self setValue:data forKey:key];
                }
            } else if (objClass) {
                [self setValue:data forKey:key];
            }
            
        } else {
            [self setValue:data forKey:key];
        }
    }
}

@end

@implementation NSArray (FastJSON)

- (NSArray *)packJsonData {
    NSMutableArray *jsonDataArray = [[NSMutableArray alloc]initWithCapacity:self.count];
    for (id object in self) {
        [jsonDataArray addObject:[object packJsonData]];
    }
    return jsonDataArray;
}

+ (NSArray *)arrayWithJsonData:(NSArray *)dataList objectClass:(nonnull Class)objClass {
    if (dataList.count == 0) {
        return nil;
    }
    if ([objClass isSubclassOfClass:[NSNumber class]] || [objClass isSubclassOfClass:[NSString class]]) {
        return dataList;
    }
    
    NSMutableArray *objectList = [[NSMutableArray alloc]initWithCapacity:dataList.count];
    id firstData = [dataList objectAtIndex:0];
    if ([firstData isKindOfClass:[NSArray class]]) {
        for (id jsonData in dataList) {
            id object = [self arrayWithJsonData:jsonData objectClass:objClass];
            [objectList addObject:object];
        }
    } else if ([firstData isKindOfClass:[NSDictionary class]]) {
        for (id jsonData in dataList) {
            id object = [NSDictionary dictionaryWithJsonData:jsonData objectClass:objClass];
            [objectList addObject:object];
        }
    } else {
        for (id jsonData in dataList) {
            id object = [[objClass alloc]initWithJsonData:jsonData];
            [objectList addObject:object];
        }
    }
    
    return objectList;
}

@end

@implementation NSDictionary (FastJSON)

+ (NSDictionary *)dictionaryWithJsonData:(NSDictionary *)dataDic objectClass:(nonnull Class)objClass {
    if (dataDic.count == 0) {
        return nil;
    }
    if ([objClass isSubclassOfClass:[NSNumber class]] || [objClass isSubclassOfClass:[NSString class]]) {
        return dataDic;
    }
    NSMutableDictionary *objectDic = [[NSMutableDictionary alloc]initWithCapacity:dataDic.count];
    id firstData = [[dataDic allValues]firstObject];
    if ([firstData isKindOfClass:[NSArray class]]) {
        [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id object = [NSArray arrayWithJsonData:obj objectClass:objClass];
            [objectDic setObject:object forKey:key];
        }];
    } else if ([firstData isKindOfClass:[NSDictionary class]]) {
        [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id object = [NSDictionary dictionaryWithJsonData:obj objectClass:objClass];
            [objectDic setObject:object forKey:key];
        }];
    } else {
        [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id object = [[objClass alloc] initWithJsonData:obj];
            [objectDic setObject:object forKey:key];
        }];
    }
    return objectDic;
}

- (NSDictionary *)packJsonData {
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if (object) {
            [jsonDic setObject:[object packJsonData] forKey:key];
        }
    }
    return jsonDic;
}

@end

@implementation NSNumber (FastJSON)

- (NSNumber *)packJsonData {
    return self;
}

@end

@implementation NSString (FastJSON)

- (NSString *)packJsonData {
    return self;
}

@end

@implementation NSData (FastJSON)

- (NSString *)packJsonData {
    return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
