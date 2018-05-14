//
//  RuntimeAutoNSCodingModel.m
//  WXD_Runtime_DEMO
//
//  Created by wxd on 2018/5/14.
//  Copyright © 2018年 wxd. All rights reserved.
//

#import "RuntimeAutoNSCodingModel.h"
#import <objc/runtime.h>

@implementation RuntimeAutoNSCodingModel

#pragma NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    RuntimeAutoNSCodingModel *copy = [[self class] allocWithZone:zone];
    if (copy) {
        if (object_getClass(self) && object_getClass(self) != [NSObject class]) {
            /*
             //实现字典和模型的自动转换
             NSDictionary *dicData;
             unsigned int outCountP = 0;
             objc_property_t * properties = class_copyPropertyList(object_getClass(self), &outCountP);
             for (int i = 0; i < outCountP; i++) {
             NSString *propertyName = [NSString stringWithUTF8String:property_getName((properties[i]))];
             NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes((properties[i]))];
             //boolType，intType，strType，numType
             //[copy setValue:[self valueForKey:ivarName] forKey:ivarName];
             //[self setValue:[dict valueForKey:key] forKey:key];
             NSLog(@"propertyName=%@,propertyAttributes=%@",propertyName,propertyAttributes);
             if ([dicData.allKeys containsObject:propertyName]) {
             [self setValue:[dicData valueForKey:propertyName] forKey:propertyName];
             }
             }
             free(properties);
             */
            
            unsigned int outCount = 0;
            Ivar *ivars = class_copyIvarList(object_getClass(self), &outCount);
            for (int i = 0; i < outCount; i++) {
                NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
                //_boolType，_intType，_strType，_numType
                [copy setValue:[self valueForKey:ivarName] forKey:ivarName];
            }
            free(ivars);
        }
        
    }
    return copy;
}

#pragma NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    /*
     [aCoder encodeObject:self.strType forKey:@"strType"];
     [aCoder encodeInteger:self.intType forKey:@"intType"];
     [aCoder encodeBool:self.boolType forKey:@"boolType"];
     [aCoder encodeObject:self.numType forKey:@"numType"];
     */
    if (object_getClass(self) && object_getClass(self) != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(object_getClass(self), &outCount);
        for (int i = 0; i < outCount; i++) {
            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
            [aCoder encodeObject:[self valueForKey:ivarName] forKey:ivarName];
        }
        free(ivars);
    }
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    RuntimeAutoNSCodingModel *model = [RuntimeAutoNSCodingModel new];
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(object_getClass(self), &outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        id value = [aDecoder decodeObjectForKey:ivarName];
        [model setValue:value forKey:ivarName];
    }
    free(ivars);
    return model;
}

@end
