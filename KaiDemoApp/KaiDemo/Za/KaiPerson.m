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
    NSLog(@"KaiPerson.saySomething %s %@", __func__, @"self.name");
//    NSLog(@"KaiPerson.saySomething %s %@", __func__, self.name);
}

- (void)otherMethod {
    NSLog(@"KaiPerson.otherMethod %s", __func__);
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

- (void)personInstanceMethod {
    NSLog(@"KaiPerson(Demo).personInstanceMethod");
}

- (void)kai_personInstanceMethod {
    NSLog(@"KaiPerson(Demo).kai_personInstanceMethod");
}

- (void)otherMethod {
    NSLog(@"KaiPerson(Demo).otherMethod %s", __func__);
}

@end
