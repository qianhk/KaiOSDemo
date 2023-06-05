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
@property (nonatomic ) int age;

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
