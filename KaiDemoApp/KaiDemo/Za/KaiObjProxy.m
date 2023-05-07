//
// Created by KaiKai on 2023/5/3.
//

#import "KaiObjProxy.h"

@interface KaiObjProxy ()

// 使用weak的话还可以用来解决NSTimer循环引用问题
// https://www.jianshu.com/p/fca3bdfca42f
@property (nonatomic, weak) NSObject *obj;

@end

@implementation KaiObjProxy
- (void)transformObjc:(NSObject *)obj {
    self.obj = obj;
}

//2.有了方法签名之后就会调用方法实现
- (void)forwardInvocation:(NSInvocation *)invocation {
    if (self.obj) {
//拦截方法的执行者为复制的对象
        [invocation setTarget:self.obj];
        if ([self.obj isKindOfClass:[NSClassFromString(@"Cat") class]]) {
//拦截参数 Argument:表示的是方法的参数 index:表示的是方法参数的下标
            NSString *str = @"拦截消息";
            [invocation setArgument:&str atIndex:2];
        }
//开始调用方法
        [invocation invoke];
    }
}

//1.查询该方法的方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *signature = nil;
    if ([self.obj methodSignatureForSelector:sel]) {
        signature = [self.obj methodSignatureForSelector:sel];
    } else {
//        signature = [super methodSignatureForSelector:sel];
    }
    return signature;
}

@end
