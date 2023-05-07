//
// Created by KaiKai on 2023/5/7.
//

#import <Foundation/Foundation.h>

@interface NSObject (DemoDelayRunLoop)

- (void)demo_doBlockAtNextRunloop:(void (^)(void))block;

@end