//
//  UIView+DefaultColor.m
//  WXD_Runtime_DEMO
//
//  Created by wxd on 2018/5/11.
//  Copyright © 2018年 wxd. All rights reserved.
//

#import "UIView+DefaultColor.h"
#import <objc/runtime.h>
const void *keyOfWxdCategoryAddVar = &keyOfWxdCategoryAddVar;
static id object;




@implementation UIView (DefaultColor)

//-(void)setDefaultColor:(UIColor *)defaultColor {
//    objc_setAssociatedObject(self, keyOfWxdCategoryAddVar, defaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (UIColor *)defaultColor {
    return objc_getAssociatedObject(self, keyOfWxdCategoryAddVar);
}

void setDefaultColorMethod(id obj, SEL _cmd, id color){
    objc_setAssociatedObject(obj, keyOfWxdCategoryAddVar, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"Doing setDefaultColorMethod");//新的testMethod函数
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(setDefaultColor:)) {
        object = self;
        const char *types = @encode(typeof(@selector(setDefaultColor:)));
        class_addMethod([self class], sel, (IMP)setDefaultColorMethod, types);
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end
