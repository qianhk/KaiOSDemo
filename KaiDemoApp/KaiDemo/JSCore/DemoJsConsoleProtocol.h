//
// Created by KaiKai on 2023/5/7.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol DemoJsConsoleProtocol<JSExport>

+ (void)log:(NSString *)msg;

+ (void)error:(NSString *)msg;

+ (void)warn:(NSString *)msg;

+ (void)kaiNewFun:(NSString *)msg;

@end

@interface DemoJsConsole : NSObject

@end
