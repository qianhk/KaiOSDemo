//
//  DemoScreenUtils.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import "DemoScreenUtils.h"
#import "DemoWindowUtils.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@implementation DemoScreenUtils

//此方法不妥，至iPhone14为止，还差390x844 393x852 430x932，将来可能差更多
+ (BOOL)isIPhoneNotchScreen2 {
    CGSize size = [DemoScreenUtils mainScreenFixedSize];
    return (CGSizeEqualToSize(CGSizeMake(375, 812), size) || CGSizeEqualToSize(CGSizeMake(414, 896), size) ||
            CGSizeEqualToSize(CGSizeMake(428, 926), size));
}

// 此方法满足至iPhone14，后续的待观察
+ (BOOL)isIPhoneNotchScreen {
    static BOOL sIPhoneNotchScreen = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            CGSize size = [DemoScreenUtils mainScreenFixedSize];
            NSInteger notchValue = (NSInteger) (size.width / size.height * 100);
            UIWindow *mainWindow = [DemoWindowUtils mainWindow];
            UIEdgeInsets safeInsets = mainWindow.safeAreaInsets;
            if (safeInsets.bottom > 0.0 || notchValue == 216 || notchValue == 46) {
                sIPhoneNotchScreen = YES;
            }
        }
    });
    return sIPhoneNotchScreen;
}

+ (CGFloat)getIPhoneNotchHeight {
    static CGFloat sNotchHeight = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([DemoScreenUtils isIPhoneNotchScreen]) {
            CGSize size = [DemoScreenUtils mainScreenFixedSize];
            //是否iPhone14的水滴屏
            BOOL pillScreen = CGSizeEqualToSize(CGSizeMake(393, 852), size) || CGSizeEqualToSize(CGSizeMake(430, 932), size);
            sNotchHeight = pillScreen ? 48 : 34;
        }
    });
    return sNotchHeight;
}

+ (CGSize)mainScreenFixedSize {
    return [UIScreen mainScreen].fixedCoordinateSpace.bounds.size;
}

+ (CGSize)mainScreenSize {
    return [UIScreen mainScreen].coordinateSpace.bounds.size;
}

@end
