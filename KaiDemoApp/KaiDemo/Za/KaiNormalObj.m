//
// Created by KaiKai on 2023/5/3.
//

#import "KaiNormalObj.h"

@implementation Cat

- (NSString *)eat:(id)obj {
    NSString *str = [NSString stringWithFormat:@"Cat eat %@", obj];
    NSLog(@"lookKai %@", str);
    return str;
}

+ (NSString *)classMethod:(id)obj {
    return [NSString stringWithFormat:@"_%@", obj];
}

@end

@implementation Dog

- (NSString *)drink:(id)obj {
    NSString *str = [NSString stringWithFormat:@"Dog drink %@", obj];
    NSLog(@"lookKai %@", str);
    return str;
}

@end

@interface KaiNormalObj ()

@property (nonatomic, strong) Cat *cat;
@property (nonatomic, strong) Dog *dog;

@end

@implementation KaiNormalObj

- (instancetype)initWithCat:(Cat *)cat andDog:(Dog *)dog {
    self = [super init];
    if (self) {
        self.cat = cat;
        self.dog = dog;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cat = [Cat new];
        self.dog = [Dog new];
    }
    return self;
}

- (NSString *)catEat:(NSString *)food {
    return [NSString stringWithFormat:@"convert_%@", [self.cat eat:food]];
}

- (NSString *)dogDrink:(NSString *)drink {
    return [NSString stringWithFormat:@"convert_%@", [self.dog drink:drink]];
}

@end