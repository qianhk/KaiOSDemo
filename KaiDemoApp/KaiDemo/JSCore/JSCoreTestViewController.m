//
//  JSCoreTestViewController.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import "JSCoreTestViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DemoJsConsoleProtocol.h"

@interface JSCoreTestViewController ()
@property (nonatomic, strong) JSVirtualMachine *jsMachine;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation JSCoreTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jsMachine = [[JSVirtualMachine alloc] init];
    self.jsContext = [[JSContext alloc] initWithVirtualMachine:self.jsMachine];
    self.jsContext.name = @"KaiDemoCustomJsContext";
    [self.jsContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
        NSLog(@"lookKai jsContext ExceptionHandler: %@", [exception toString]);
    }];
    [self.jsContext setObject:[DemoJsConsole class] forKeyedSubscript:@"console"];
//    [self.jsContext setObject:self.xxx forKeyedSubscript:@"xxx"]; 也可以是一个实例
    [self addOneTest:@"str 1+2*3" selector:@selector(simpleInvoke)];
    [self addOneTest:@"invokeFromJsFile" selector:@selector(invokeFromJsFile)];
}

- (void)simpleInvoke {
    JSVirtualMachine *vm = [[JSVirtualMachine alloc] init];
    JSContext *context = [[JSContext alloc] initWithVirtualMachine:vm];
    JSValue *value = [context evaluateScript:@"1+2*3"];
//    BOOL notch = [NotchScreenUtil isIPhoneNotchScreen];
//    BOOL notch2 = [NotchScreenUtil isIPhoneNotchScreen2];
//    CGFloat notchHeight = [NotchScreenUtil getIPhoneNotchHeight];
    NSLog(@"lookKai value=%d", [value toInt32]);
}

- (void)invokeFromJsFile {
    NSString *commonJsPath = [[NSBundle mainBundle] pathForResource:@"testCommon" ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:commonJsPath encoding:NSUTF8StringEncoding error:nil];
    if (jsContent == nil && jsContent.length <= 0) {
        NSLog(@"lookKai no jsContent, %@", jsContent);
        return;
    }
    NSLog(@"lookKai jsContent, len=%ld", jsContent.length);
    [self.jsContext evaluateScript:jsContent withSourceURL:[NSURL URLWithString:@"testCommon.js"]];
    JSValue *sumFun = [self.jsContext objectForKeyedSubscript:@"kaiTestSum"];
    JSValue *sumResultValue = [sumFun callWithArguments:@[@4, @2, @3]];
    NSLog(@"lookKai sumFun=%@ obj=%@ sumResultValue=%@ toXxx=%@ type=%@", sumFun, NSStringFromClass([sumFun.toObject class]),
            sumResultValue, sumResultValue.toObject, NSStringFromClass([sumResultValue.toObject class]));
    JSValue *returnMapFun = [self.jsContext objectForKeyedSubscript:@"kaiTestReturnMap"];
    JSValue *mapResultValue = [returnMapFun callWithArguments:@[@4, @2, @3]];
    NSLog(@"lookKai sumResultValue=%@ toXxx=%@ type=%@", mapResultValue, mapResultValue.toObject, NSStringFromClass([mapResultValue.toObject class]));
    JSValue *aBoolValue = [self.jsContext objectForKeyedSubscript:@"aBool"];
    NSLog(@"lookKai aBoolValue=%@ obj=%@ type=%@", aBoolValue, aBoolValue.toObject, NSStringFromClass([aBoolValue.toObject class]));
}

@end
