//
// Created by KaiKai on 2023/5/7.
//

#import "DemoJsConsoleProtocol.h"

@interface DemoJsConsole ()<DemoJsConsoleProtocol>
@end

@implementation DemoJsConsole

+ (void)log:(NSString *)msg {
    NSLog(@"[JSConsoleLOG] :%@", msg);
}

+ (void)error:(NSString *)msg {
    NSLog(@"[JSConsoleERROR]:%@", msg);
}

+ (void)warn:(NSString *)msg {
    NSLog(@"[JSConsoleWARN] :%@", msg);
}

+ (void)kaiNewFun:(NSString *)msg {
    NSLog(@"[KaiNewFunInOc] :%@", msg);
}

@end