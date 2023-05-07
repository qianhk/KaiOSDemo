//
//  DemoToast.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import "DemoToast.h"
#import "DemoWindowUtils.h"
#import "DemoScreenUtils.h"

@interface DialogsLabel : UILabel

- (void)setMessageText:(NSString *)text;

@end

@interface DemoToast () {
    DialogsLabel *dialogsLabel;
    NSTimer *countTimer;
    NSInteger changeCount;
}
@end

@implementation DemoToast

+ (instancetype)shareInstance {
    static DemoToast *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            singleton = [DemoToast new];
    });
    return singleton;
}

+ (void)toast:(NSString *)message {
    [[DemoToast shareInstance] makeToast:message];
}

+ (void)toast:(NSString *)message duration:(NSInteger)duration {
    [[DemoToast shareInstance] makeToast:message duration:duration];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dialogsLabel = [[DialogsLabel alloc] init];
        countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        countTimer.fireDate = [NSDate distantFuture];//关闭定时器
        [[DemoWindowUtils mainWindow] addSubview:dialogsLabel];
    }
    return self;
}

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:1];
}

- (void)makeToast:(NSString *)message duration:(NSInteger)duration {
    if ([message length] == 0) {
        return;
    }
    [dialogsLabel setMessageText:message];
    dialogsLabel.hidden = NO;
    dialogsLabel.alpha = 0.8;
    countTimer.fireDate = [NSDate distantFuture];//关闭定时器
    countTimer.fireDate = [NSDate distantPast];//开启定时器
    changeCount = duration;
}

- (void)changeTime {
    if (changeCount-- <= 0) {
        countTimer.fireDate = [NSDate distantFuture];//关闭定时器
        [UIView animateWithDuration:0.2f animations:^{
                    dialogsLabel.alpha = 0;
                }
                         completion:^(BOOL finished) {
                             dialogsLabel.hidden = YES;
                         }];
    }
}


@end

@implementation DialogsLabel
//DialogsLabel初始化，为label设置各种属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setMessageText:(NSString *)text {
    [self setText:text];
    CGFloat screenWidth = [DemoScreenUtils mainScreenFixedSize].width;
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(screenWidth - 20, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName: self.font}
                                          context:nil];
    CGFloat width = rect.size.width + 20;
    CGFloat height = rect.size.height + 20;
    CGFloat x = (screenWidth - width) / 2;
    CGFloat y = screenWidth - height - 59;
    self.frame = CGRectMake(x, y, width, height);
}

@end
