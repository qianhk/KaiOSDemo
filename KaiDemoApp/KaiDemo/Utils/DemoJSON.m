//
//  DemoJSON.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import "DemoJSON.h"

@interface DemoJSON : NSObject

+ (id)demo_objectFromJSONString:(NSString *)jsonString;

+ (NSString *)demo_jsonStringFromObj:(id)obj defaultValue:(NSString *)defaultValue;

@end

@implementation DemoJSON

+ (id)demo_objectFromJSONString:(NSString *)jsonString {
    if (jsonString == nil || jsonString.length == 0) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil || data.length == 0) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

+ (NSString *)demo_jsonStringFromObj:(id)obj defaultValue:(NSString *)defaultValue {
    if (obj == nil) {
        return defaultValue;
    }
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return defaultValue;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    if (error || jsonData == nil) {
        return defaultValue;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (DEMO_JSON)

- (id)demo_objectFromJsonString {
    return [DemoJSON demo_objectFromJSONString:self];
}

@end

@implementation NSDictionary (DEMO_JSON)
- (NSString *)demo_jsonString {
    return [DemoJSON demo_jsonStringFromObj:self defaultValue:@"{}"];
}
@end

@implementation NSArray (DEMO_JSON)
- (NSString *)demo_jsonString {
    return [DemoJSON demo_jsonStringFromObj:self defaultValue:@"[]"];
}
@end
