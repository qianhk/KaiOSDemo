//
//  DemoJSON.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSString (DEMO_JSON)

- (id)demo_objectFromJsonString;

@end

@interface NSDictionary (DEMO_JSON)

- (NSString *)demo_jsonString;

@end

@interface NSArray (DEMO_JSON)

- (NSString *)demo_jsonString;

@end

NS_ASSUME_NONNULL_END
