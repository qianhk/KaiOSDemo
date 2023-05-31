//
//  DemoRuntimeUtils.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/30.
//

#import "DemoRuntimeUtils.h"
#import <objc/runtime.h>

@implementation DemoRuntimeUtils

+ (void)methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL {
    if (!cls) {
        NSLog(@"传入的交换类不能为空");
    }
    
    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    if (!oriMethod) {
        // 在oriMethod为nil时，替换后将swizzledSEL复制一个不做任何事的空实现,代码如下:
        class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    
    // 一般交换方法: 交换自己有的方法 -- 走下面 因为自己有意味添加方法失败
    // 交换自己没有实现的方法:
    //   首先第一步:会先尝试给自己添加要交换的方法 :personInstanceMethod (SEL) -> swiMethod(IMP)
    //   然后再将父类的IMP给swizzle  personInstanceMethod(imp) -> swizzledSEL
    //oriSEL:personInstanceMethod

    BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else{
        method_exchangeImplementations(oriMethod, swiMethod);
    }
}

+ (void)methodSwizzlingWithClass2:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL {
    if (!cls) {
        NSLog(@"传入的交换类不能为空");
    }

    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    BOOL success = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(oriMethod));
    /**
        from https://juejin.cn/post/6844904142368931853
            如果派生类也有oriSel的实现，则success为false，交换；
            如果派生类无oriSel的实现，则success为true，替换
     
            父类调用的方法不受影响，是原始的、未修改过的；
     */
    if (success) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swiMethod);
    }
}

+ (void)methodSwizzlingWithClass1:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL {
    if (!cls) {
        NSLog(@"传入的交换类不能为空");
    }

    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    BOOL success = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(oriMethod));

    /**
        from https://juejin.cn/post/6844904142368931853
        这个文章里有关method Swizzling的貌似过时了，至少在iOS14，直接exchange也不会crash，父类也正常执行了子类修改的方法
     */
    method_exchangeImplementations(oriMethod, swiMethod);
}

@end
