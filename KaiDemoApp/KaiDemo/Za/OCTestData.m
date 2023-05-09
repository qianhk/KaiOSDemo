//
//  OCTestData.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/9.
//

#import "OCTestData.h"

@implementation OCTestData

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"index=%li", self.index];
    [description appendFormat:@", name=%@", self.name];
    [description appendFormat:@", arrayTest=%@", self.arrayTest];
    [description appendFormat:@", otherStr=%@", self.otherStr];
    [description appendFormat:@", otherDic=%@", self.otherDic];
    [description appendString:@">"];
    return description;
}

@end
