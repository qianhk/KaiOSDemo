//
//  DemoRuntimeUtils.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoRuntimeUtils : NSObject

+ (void)methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL;

@end

NS_ASSUME_NONNULL_END
