//
//  DemoTextInputView.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoTextInputView : UIView

@property (nonatomic, copy) void (^completion)(NSString *content);

- (void)showKeyboardWithParentView:(UIView *)parentView;

- (void)dismissKeyboard;

@end

NS_ASSUME_NONNULL_END
