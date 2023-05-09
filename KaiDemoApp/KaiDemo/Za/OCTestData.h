//
//  OCTestData.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/9.
//

#import <Foundation/Foundation.h>

//如果 无 NS_ASSUME_NONNULL_BEGIN, 那么对应到swift里是Optional类型，如有是不为空的类型，字符串默认空字符串

NS_ASSUME_NONNULL_BEGIN

@interface OCTestData : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *arrayTest;
@property (nonatomic, strong) NSString *_Nullable otherStr;
@property (nonatomic, strong) NSDictionary<NSString *, id> *_Nullable otherDic;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
