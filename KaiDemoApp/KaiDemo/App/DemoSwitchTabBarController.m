//
//  DemoSwitchController.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/3.
//

#import "DemoSwitchTabBarController.h"
#import "DemoEntryViewController.h"
#import "DemoNavigationController.h"
#import "KaiDemo-Swift.h"

@interface DemoSwitchTabBarController () {
    
}

@end

@implementation DemoSwitchTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    DemoEntryViewController *entryViewTabVc = [DemoEntryViewController new];
    entryViewTabVc.title = @"凯Demo";
    DemoNavigationController *navEntry = [[DemoNavigationController alloc] initWithRootViewController:entryViewTabVc];
    navEntry.tabBarItem.image = [UIImage imageNamed:@"TabItemList"];
    navEntry.tabBarItem.title = @"Demo";
    
    SwiftDemoEntryViewController *swiftTabVc = [SwiftDemoEntryViewController new];
    swiftTabVc.title = @"Swift Demo";
    DemoNavigationController *navSwift = [[DemoNavigationController alloc] initWithRootViewController:swiftTabVc];
    navSwift.tabBarItem.image = [UIImage imageNamed:@"TabItemSwift"];
    navSwift.tabBarItem.title = @"Swift";
    
    AboutViewController *aboutTabDevice = [AboutViewController new];
    aboutTabDevice.tabBarItem.image = [UIImage imageNamed:@"TabItemDevice"];
    aboutTabDevice.tabBarItem.title = @"设备";
    aboutTabDevice.view.backgroundColor = [UIColor whiteColor];
    
    AboutViewController *aboutTabVc = [AboutViewController new];
    aboutTabVc.tabBarItem.image = [UIImage imageNamed:@"TabItemInfo"];
    aboutTabVc.tabBarItem.title = @"关于";
    
    self.viewControllers = @[navEntry, navSwift, aboutTabDevice, aboutTabVc];
    
    self.selectedIndex = 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
