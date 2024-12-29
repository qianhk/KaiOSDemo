//
// Created by KaiKai on 2023/5/3.
//

#import <objc/runtime.h>
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
#import "KaiPerson.h"
#import "JSCoreTestViewController.h"

@implementation ZaTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addOneTest:@"Proxy Cat Dog" selector:@selector(proxyCatDog)];
    [self addOneTest:@"无强引用也内存泄露" selector:@selector(leakWithoutStrongRef)];
    [self addOneTest:@"demo input view" selector:@selector(demoInputView)];
    [self addOneTest:@"Toast" selector:@selector(testToast)];
    [self addOneTest:@"Long Toast" selector:@selector(testLongToast)];
    [self addOneTest:@"调用Swift语法测试" selector:@selector(invokeSwiftSyntax)];
    [self addOneTest:@"method swizzle" selector:@selector(methodSwizzle)];
    [self addOneTest:@"global_queue数量" selector:@selector(globalQueueCount)];
    [self addOneTest:@"open new vc" selector:@selector(openNewVc)];
}

- (void)globalQueueCount {
    dispatch_queue_global_t queue_high1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0); // 2
    dispatch_queue_global_t queue_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 0
    dispatch_queue_global_t queue_low = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0); // -2
    dispatch_queue_global_t queue_bkg = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0); // INT16_MIN
    dispatch_queue_global_t queue_high2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    NSLog(@"lookKai priority queue high1=%p high2=%p default=%p low=%p bkg=%p", queue_high1, queue_high2, queue_default, queue_low, queue_bkg);
    //queue_high1 == queue_high2 4个优先级 4种全局队列
    
    dispatch_queue_global_t queue_qos_user_interactive = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0); // 0x21
    dispatch_queue_global_t queue_qos_user_initiated = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0); // 0x19
    dispatch_queue_global_t queue_qos_default = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0); // 0x15
    dispatch_queue_global_t queue_qos_utility = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0); // 0x11
    dispatch_queue_global_t queue_qos_bkg = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);  // 0x9
    dispatch_queue_global_t queue_qos_unspecified = dispatch_get_global_queue(QOS_CLASS_UNSPECIFIED, 0); // 0x0
    NSLog(@"lookKai qos queue userInteractive=%p userInitiated=%p default=%p utility=%p bkg=%p unspecified=%p"
          , queue_qos_user_interactive, queue_qos_user_initiated, queue_qos_default, queue_qos_utility, queue_qos_bkg, queue_qos_unspecified);
    // 6个参数，由于unspecified队列等于default队列，共5种队列
    
    // 相同的队列，映射关系
    // DISPATCH_QUEUE_PRIORITY_HIGH == QOS_CLASS_USER_INITIATED
    // DISPATCH_QUEUE_PRIORITY_DEFAULT == QOS_CLASS_DEFAULT == QOS_CLASS_UNSPECIFIED
    // DISPATCH_QUEUE_PRIORITY_LOW == QOS_CLASS_UTILITY
    // DISPATCH_QUEUE_PRIORITY_BACKGROUND == QOS_CLASS_BACKGROUND
    
    // 综合下来，排除重复的，共可以创建5种系统全局队列
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
//    [proxy transformObjc:nil];
//    [proxy performSelector:@selector(drink:) withObject:@"不存在obj了"];
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

- (void)methodSwizzle {
//    NSString *tem = @"KaiHaha";
    NSDictionary *testDic = @{@"key1":@"value1"};
//    NSDictionary *testDic2 = @{@"key2":@"value2"};
    int _age = 123;
    id pcls = [KaiStudent class];
    void *pp = &pcls;
    [(__bridge id)pp saySomething]; // 与文章不同，如果使用属性，那么此处crash，不使用属性就正常，毕竟并没有new实例
    
    KaiStudent *student = [KaiStudent new];
    student.name = @"KaiStudentName";
    [student saySomething];
//    id pcls2 = student;
//    void *pp2 = &pcls2;
//    [(__bridge id)pp2 saySomething];
    NSLog(@"lookKai will invoke [student personInstanceMethod]");
    [student personInstanceMethod];
    NSLog(@"lookKai will invoke [student kai_personInstanceMethod]");
    [student kai_personInstanceMethod];
    
    KaiPerson *person = [KaiPerson new];
    person.name = @"KaiPersonName";
    NSLog(@"lookKai will invoke [person personInstanceMethod]");
    [person personInstanceMethod];
    
    [student otherMethod];
    [self callClassMethod:student];
    
    int age=10;
    void (^testBlock)(void) = ^{
        NSLog(@"age:%d",age); // age:10 应该是创建block时捕获的，而非运行前
    };
    age = 20;
    testBlock();
    
    __block int a = 0;
    NSLog(@"定义前：%p", &a);         //栈区
    void (^foo)(void) = ^{
        a = 1;
        NSLog(@"block内部：%p", &a);    //堆区
    };
    NSLog(@"定义后：%p", &a);         //堆区
    foo();
    [NSUserDefaults standardUserDefaults];
}

// 分类重写原类方法时，如何调用原类方法
// https://juejin.cn/post/6844903874768158727
- (void)callClassMethod:(KaiStudent *)student {
    u_int count;
    Method *methods = class_copyMethodList([KaiPerson class], &count);
    NSInteger index = 0;
    
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];

        if ([strName isEqualToString:@"otherMethod"]) {
            index = i;  // 先获取原类方法在方法列表中的索引
            // 注意此处并没有break，而是继续找，因为原类方法在后面
        }
    }
    
    // 调用方法
    SEL sel = method_getName(methods[index]);
    IMP imp = method_getImplementation(methods[index]);
    ((void (*)(id, SEL))imp)(student,sel);
}

- (void)openNewVc {
    UIViewController *vc = [JSCoreTestViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"lookKai testVC viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"lookKai testVC viewWillDisappear");
}


@end
