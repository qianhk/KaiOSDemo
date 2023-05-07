//
// Created by KaiKai on 2023/5/3.
//

#import "ZaTestListViewController.h"
#import "KaiNormalObj.h"
#import "KaiObjProxy.h"
#import "DemoSynchronize.h"
#import "NSObject+DemoDelayRunLoop.h"
#import "NSObject+DemoRuntimeInvoke.h"

@implementation ZaTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addOneTest:@"Proxy Cat Dog" selector:@selector(proxyCatDog)];
    [self addOneTest:@"无强引用也内存泄露" selector:@selector(leakWithoutStrongRef)];
    [self addOneTest:@"demo input view" selector:@selector(demoInputView)];
    [self addOneTest:@"Toast" selector:@selector(testToast)];
    [self addOneTest:@"Long Toast" selector:@selector(testLongToast)];
}

- (void)testToast {
    Demo_onMainThread(^{
//    [DemoToast toast:@"Haha Toast"];
    });
}

- (void)testLongToast {
    [NSObject demo_doBlockAtNextRunloop:^{
//    [DemoToast toast:@"Haha Toast Long Time" duration:3];
    }];
}

- (void)demoInputView {
    Cat *cat = [[Cat alloc] init];
    [cat invoke:@"eat:" arguments:@[@"猫食"]];
//        DemoTextInputView *inputView = [DemoTextInputView new];
//        [inputView showkeyboardWithType:NO parentView:self.view];
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
        NSLog(@"lookkai catch leakWithoutStrongRef exception: %@", exception);
    } @finally {
    
    }
}

@end
