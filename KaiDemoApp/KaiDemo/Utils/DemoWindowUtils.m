//
//  DemoWindowUtils.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import <UIKit/UIKit.h>
#import "DemoWindowUtils.h"

@implementation DemoWindowUtils

+ (UIWindow *)mainWindow {
    UIWindow *win = [[[UIApplication sharedApplication] delegate] window];
    if (win == nil) {
        win = [[UIApplication sharedApplication] keyWindow];
    }
    if (win == nil) {
        win = [[UIApplication sharedApplication] windows].firstObject;
    }
    return win;
}


@end
