//
// Created by KaiKai on 2023/5/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cat : NSObject

- (NSString *)eat:(id)obj;

+ (NSString *)classMethod:(id)obj;

@end

@interface Dog : NSObject

- (NSString *)drink:(id)obj;

@end

@interface KaiNormalObj : NSObject

- (instancetype)initWithCat:(Cat *)cat andDog:(Dog *)dog;

- (NSString *)catEat:(NSString *)food;

- (NSString *)dogDrink:(NSString *)drink;

@end

NS_ASSUME_NONNULL_END