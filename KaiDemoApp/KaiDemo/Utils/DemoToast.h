//
//  DemoToast.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoToast : NSObject

+ (void)toast:(NSString *)message;

+ (void)toast:(NSString *)message duration:(NSInteger)duration;

@end

NS_ASSUME_NONNULL_END
