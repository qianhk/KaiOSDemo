//
// Created by KaiKai on 2023/5/3.
//

#import "ZaTestListViewController.h"
#import "KaiNormalObj.h"
#import "KaiObjProxy.h"

@implementation ZaTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addOneTest:@"Proxy Cat Dog" selector:@selector(proxyCatDog)];
    [self addOneTest:@"无强引用也内存泄露" selector:@selector(leakWithoutStrongRef)];
    [self addOneTest:@"demo input view" selector:@selector(demoInputView)];
}

- (void)demoInputView {
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
    [proxy transformObjc:dog];
    [proxy performSelector:@selector(drink:) withObject:@"狗之饮料2"];
    KaiNormalObj *normal0bj = [KaiNormalObj new];
    NSLog(@"%@", [normal0bj catEat:@"猫食"]);
    NSLog(@"%@", [normal0bj dogDrink:@"狗水"]);
}

- (void)leakWithoutStrongRef {
    @try {
        KaiNormalObj *obj = [KaiNormalObj new];
        [@[] objectAtIndex:1]; //由于异常，作用域尾部对objrelease的操作跳过了，使得引用计数始终为1
    } @catch (NSException *exception) {
        NSLog(@"lookkai catch leakWithoutStrongRef exception");
    } @finally {
    
    }
}

@end