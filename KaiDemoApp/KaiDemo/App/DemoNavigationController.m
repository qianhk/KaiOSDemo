//
//  DemoNavigationController.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/3.
//

#import "DemoNavigationController.h"

@interface DemoNavigationController ()

@end

@implementation DemoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 注意：这是个正确的写法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (BOOL)shouldAutorotate {
//    return self.topViewController.shouldAutorotate;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return self.topViewController.supportedInterfaceOrientations;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return self.topViewController.preferredInterfaceOrientationForPresentation;
//}

@end
