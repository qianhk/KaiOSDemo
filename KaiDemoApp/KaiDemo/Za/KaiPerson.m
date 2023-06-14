//
//  KaiPerson.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/30.
//

#import "KaiPerson.h"
#import "DemoRuntimeUtils.h"

@implementation KaiPerson

- (void)personInstanceMethod {
    NSLog(@"KaiPerson.personInstanceMethod");
}

+ (void)personClassMethod {
    NSLog(@"KaiPerson.personClassMethod");
}

- (void)saySomething {
    NSLog(@"KaiPerson.saySomething %s %@", __func__, self.name);
//    NSLog(@"KaiPerson.saySomething %s %@", __func__, self.name);
}

- (void)otherMethod {
    NSLog(@"KaiPerson.otherMethod %s name=%@", __func__, self.name);
}

@end

@implementation KaiStudent



@end

@implementation KaiStudent (Demo)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DemoRuntimeUtils methodSwizzlingWithClass:self oriSEL:@selector(personInstanceMethod) swizzledSEL:@selector(kai_personInstanceMethod)];
    });
}

//- (void)personInstanceMethod {
//    NSLog(@"KaiStudent(Demo).personInstanceMethod");
//}

- (void)kai_personInstanceMethod {
    NSLog(@"KaiStudent(Demo).kai_personInstanceMethod");
    
    //被交换后，此处想调用原来的方法得调用自己这个selector，因为这个selector对应的实现IMPL被修改成原来的的
//    [self kai_personInstanceMethod];
}

- (void)otherMethod {
    NSLog(@"KaiStudent(Demo).otherMethod %s name=%@", __func__, self.name);
}

@end
