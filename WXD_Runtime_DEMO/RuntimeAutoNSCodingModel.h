//
//  RuntimeAutoNSCodingModel.h
//  WXD_Runtime_DEMO
//
//  Created by wxd on 2018/5/14.
//  Copyright © 2018年 wxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeAutoNSCodingModel : NSObject<NSCoding,NSCopying>
@property (nonatomic,copy) NSString *strType;
@property (nonatomic,assign) int intType;
@property (nonatomic,assign) BOOL boolType;
@property (nonatomic,strong) NSNumber *numType;
@end
