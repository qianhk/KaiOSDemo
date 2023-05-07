//
//  DemoScreenUtils.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoScreenUtils : NSObject

+ (BOOL)isIPhoneNotchScreen;

+ (CGFloat)getIPhoneNotchHeight;

+ (CGSize)mainScreenFixedSize;

+ (CGSize)mainScreenSize;

@end

NS_ASSUME_NONNULL_END
