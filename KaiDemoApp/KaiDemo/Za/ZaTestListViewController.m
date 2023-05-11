//
// Created by KaiKai on 2023/5/3.
//

#import "ZaTestListViewController.h"
#import "KaiNormalObj.h"
#import "KaiObjProxy.h"
#import "DemoSynchronize.h"
#import "NSObject+DemoDelayRunLoop.h"
#import "NSObject+DemoRuntimeInvoke.h"
#import "DemoToast.h"
#import "DemoScreenUtils.h"
#import "DemoJSON.h"
#import "DemoTextInputView.h"
#import "KaiDemo-Swift.h"

@implementation ZaTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addOneTest:@"Proxy Cat Dog" selector:@selector(proxyCatDog)];
    [self addOneTest:@"无强引用也内存泄露" selector:@selector(leakWithoutStrongRef)];
    [self addOneTest:@"demo input view" selector:@selector(demoInputView)];
    [self addOneTest:@"Toast" selector:@selector(testToast)];
    [self addOneTest:@"Long Toast" selector:@selector(testLongToast)];
    [self addOneTest:@"调用Swift语法测试" selector:@selector(invokeSwiftSyntax)];
}

- (void)testToast {
    NSDictionary *testDic = @{@"key1": @"value1", @"key2": @222};
    NSArray *testArray = @[@"abc", @123];
    NSString *str1 = [testDic demo_jsonString];
    NSString *str2 = [testArray demo_jsonString];
    id resultDic = [str1 demo_objectFromJsonString];
    id resultArray = [str2 demo_objectFromJsonString];
    Demo_onMainThread(^{
        [DemoToast toast:@"Haha Default Toast"];
    });
}

- (void)testLongToast {
    [NSObject demo_doBlockAtNextRunloop:^{
        NSString *msg = [NSString stringWithFormat:@"screen notchHeight=%.0f fixSize=%@ size=%@"
                , [DemoScreenUtils getIPhoneNotchHeight]
                , NSStringFromCGSize([DemoScreenUtils mainScreenFixedSize])
                , NSStringFromCGSize([DemoScreenUtils mainScreenSize])];
        [DemoToast toast:msg duration:3];
    }];
}

- (void)demoInputView {
    Cat *cat = [[Cat alloc] init];
    [cat invoke:@"eat:" arguments:@[@"猫食"]];
    DemoTextInputView *inputView = [DemoTextInputView new];
    inputView.completion = ^(NSString *content) {
        NSLog(@"lookKai keyboard input len=%ld: %@", content.length, content);
    };
    [inputView showKeyboardWithParentView:self.view];
}

- (void)proxyCatDog {
    Cat *cat = [[Cat alloc] init];
    Dog *dog = [[Dog alloc] init];
    [cat eat:@"猫之食物1"];
    [dog drink:@"狗之饮料1"];
    KaiObjProxy *proxy = [KaiObjProxy alloc];
    [proxy transformObjc:cat];
    [proxy performSelector:@selector(eat:) withObject:@"猫之食物2"];
//    [proxy performSelector:@selector(eat2:) withObject:@"猫之食物2_2"];
    [proxy transformObjc:dog];
    [proxy performSelector:@selector(drink:) withObject:@"狗之饮料2"];
    KaiNormalObj *normalObj = [KaiNormalObj new];
    NSLog(@"%@", [normalObj catEat:@"猫食"]);
    NSLog(@"%@", [normalObj dogDrink:@"狗水"]);
}

- (void)leakWithoutStrongRef {
    KaiNormalObj *obj1;
    @try {
//        obj1 = [KaiNormalObj new];
        KaiNormalObj *obj2 = [KaiNormalObj new];
        [@[] objectAtIndex:1]; //由于异常，作用域尾部对obj2 release的操作跳过了，使得引用计数始终为1
    } @catch (NSException *exception) {
        NSLog(@"lookKai catch leakWithoutStrongRef exception: %@", exception);
    } @finally {
    
    }
}

- (void)invokeSwiftSyntax {
    TestSwiftSyntax *swift = [TestSwiftSyntax new];
    swift.name = @"OcName";
    swift.other = @"OcOther";
    NSLog(@"lookKai in .m testSwiftSyntax1 = %@", swift.simpleDescription);
    swift.nextYearAge = 10;
    NSLog(@"lookKai in .m testSwiftSyntax2 = %@", swift.simpleDescription);
    [swift demoEntryFunction];
    [ControlFlowEntry entry];
}

@end
