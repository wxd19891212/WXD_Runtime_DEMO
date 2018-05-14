//
//  ViewController.m
//  WXD_Runtime_DEMO
//
//  Created by wxd on 2018/5/11.
//  Copyright © 2018年 wxd. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "UIView+DefaultColor.h"

#import "RuntimeAutoNSCodingModel.h"

@interface Person: NSObject

@end

@implementation Person

- (void)testMethod:(id)str{
    NSLog(@"Person: testMethod:");//Person的testMethod函数
}

@end


@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //SEL originalSelector = @selector(viewDidLoad);
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(wxdViewDidLoad);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)wxdViewDidLoad {
    NSLog(@"替换的方法");
    [self wxdViewDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"自带的方法");
    //[self performSelector:@selector(testMethod)];
    [self performSelector:@selector(testMethod:) withObject:@"wxd"];
    
    
    self.view.defaultColor = [UIColor redColor];
    NSLog(@"self.view.defaultColor=%@",self.view.defaultColor);
    
    RuntimeAutoNSCodingModel *model = [[RuntimeAutoNSCodingModel alloc] init];
    model.strType = @"strType";
    model.intType = 2;
    model.boolType = YES;
    model.numType = [NSNumber numberWithFloat:2.5];
    
    RuntimeAutoNSCodingModel *copyModel = [model copy];
    NSLog(@"strType = %@,boolType = %d,numType = %@,intType = %d",copyModel.strType,copyModel.boolType,copyModel.numType,copyModel.intType);
    
    /*
     //获取文件路径
     NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
     NSString *filePath = [documentPath stringByAppendingPathComponent:@"archiverFile"];
     BOOL result = [NSKeyedArchiver archiveRootObject:copyModel toFile:filePath];
     if (result) {
     NSLog(@"归档成功:%@",filePath);
     }else
     {
     NSLog(@"归档失败");
     }
     
     RuntimeAutoNSCodingModel *unarchiverModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
     
     NSLog(@"%@",unarchiverModel);
     */
    
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    /*
     if (sel == @selector(testMethod:)) {
     //https://www.jianshu.com/p/54c190542aa8  为什么object_getClass(obj)与[OBJ class]返回的指针不同
     
     Class _clsA = object_getClass(self);//返回isa指针
     Class _clsB = [self class];//返回自己
     const char *types = @encode(typeof(@selector(testMethod:)));
     class_addMethod([self class], sel, (IMP)testMethodIMP, types);
     return YES;
     }
     return [super resolveInstanceMethod:sel];
     */
    return YES;
}
/*
 完整消息转发
 如果在这一步还不能处理未知消息，则唯一能做的就是启用完整的消息转发机制了。
 首先它会发送-methodSignatureForSelector:消息获得函数的参数和返回值类型。如果-methodSignatureForSelector:返回nil ，Runtime则会发出 -doesNotRecognizeSelector: 消息，程序这时也就挂掉了。如果返回了一个函数签名，Runtime就会创建一个NSInvocation 对象并发送 -forwardInvocation:消息给目标对象。
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    /*
     if (aSelector == @selector(testMethod:)) {
     return [Person new];//返回Person对象，让Person对象接收这个消息
     }
     return [super forwardingTargetForSelector:aSelector];
     */
    return nil;//返回nil，进入下一步转发
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(testMethod:)) {
        const char *types = method_getTypeEncoding(class_getInstanceMethod(object_getClass([Person new]), @selector(testMethod:)));
        return [NSMethodSignature signatureWithObjCTypes:types];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    Person *p = [Person new];
    if ([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    }
    else {
        [self doesNotRecognizeSelector:sel];
    }
}

void testMethodIMP(id obj, SEL _cmd){
    NSLog(@"Doing testMethod");//新的testMethod函数
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
