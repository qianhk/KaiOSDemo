//
//  KaiPerson.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KaiPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic ) int age; // 为啥加个age， [(__bridge id)pp saySomething]前不定义两个栈变量就会crash，似乎地址不只是+8而是+16了
//@property (nonatomic) int age2;

- (void)personInstanceMethod;

+ (void)personClassMethod;

- (void)saySomething;

- (void)otherMethod;

@end

@interface KaiStudent : KaiPerson

@end

@interface KaiStudent (Demo)

- (void)kai_personInstanceMethod;
- (void)otherMethod;

@end

NS_ASSUME_NONNULL_END
