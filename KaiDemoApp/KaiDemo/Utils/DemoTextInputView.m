//
//  DemoTextInputView.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/9.
//

#import "DemoTextInputView.h"
#import "DemoScreenUtils.h"

@interface DemoTextInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIView *wrapInputView;
@property (nonatomic, strong) UITextField *inputTextField;

@end

@implementation DemoTextInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestures];
        [self registerNotifications];
    }
    return self;
}

- (void)addGestures {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)showKeyboardWithParentView:(UIView *)parentView {
    if (self.superview) {
        return;
    }
    [parentView addSubview:self];
    NSLog(@"lookKai showKeyboardWithType parentSize=%@", NSStringFromCGSize(parentView.bounds.size));
    self.frame = parentView.bounds;
    UIWindow *win = self.window;
    if (![win isKeyWindow]) {
        [win makeKeyWindow];
    }
    self.inputTextField.secureTextEntry = NO;
    [self.inputTextField becomeFirstResponder];
#if TARGET_OS_MACCATALYST
    [self keyboardwillShow:nil];
#endif
}

- (void)dismissKeyboard {
    if (self.superview) {
//        NSLog(@"lookKai dismissKeyboard");
        [self endEditing:YES];
        [self removeFromSuperview];
        _inputTextField.text = @"";
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
//    NSLog(@"lookKai keyboardDidHide");
    [self dismissKeyboard];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.superview) {
        return;
    }
    self.toolView.hidden = NO;
    CGRect end = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(end);
    NSTimeInterval keyboardDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:keyboardDuration
                     animations:^{
                         UIView *curToolView = self.toolView;
                         CGSize pSize = self.frame.size;
                         curToolView.frame = CGRectMake(curToolView.frame.origin.x, pSize.height - keyboardHeight -
                                         curToolView.frame.size.height,
                                 pSize.width, curToolView.frame.size.height);
//                         NSLog(@"lookKai keyboardShow landscape=%@ endRect=%@", @(_isLandscape), NSStringFromCGRect(end));
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendBizText:textField];
    [self dismissKeyboard];
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (CGRectContainsPoint(self.toolView.frame, [tap locationInView:self])) {
        return;
    }
    [self dismissKeyboard];
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor lightGrayColor];
            view.frame = CGRectMake(0, self.bounds.size.height + 100, self.bounds.size.width, 40);
            [self addSubview:view];
            view;
        });
    }
    return _toolView;
}

- (UIView *)wrapInputView {
    if (!_wrapInputView) {
        CGFloat notchWidth = [DemoScreenUtils getIPhoneNotchHeight];
        _wrapInputView = [UIView new];
        _wrapInputView.layer.cornerRadius = 15;
        _wrapInputView.backgroundColor = [UIColor whiteColor];
        [self.toolView addSubview:_wrapInputView];
        _wrapInputView.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat extraOffset = 0;
        [NSLayoutConstraint activateConstraints:@[
                [_wrapInputView.leadingAnchor constraintEqualToAnchor:_toolView.leadingAnchor constant:extraOffset + notchWidth],
                [_wrapInputView.trailingAnchor constraintEqualToAnchor:_toolView.trailingAnchor constant:-(extraOffset + notchWidth)],
                [_wrapInputView.topAnchor constraintEqualToAnchor:_toolView.topAnchor constant:5],
                [_wrapInputView.heightAnchor constraintEqualToConstant:30]
        ]];
    }
    return _wrapInputView;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [UITextField new];
        _inputTextField.delegate = self;
        _inputTextField.backgroundColor = nil;
        _inputTextField.returnKeyType = UIReturnKeyDone;
        [self.wrapInputView addSubview:_inputTextField];
        _inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                [_inputTextField.leadingAnchor constraintEqualToAnchor:_wrapInputView.leadingAnchor constant:12],
                [_inputTextField.topAnchor constraintEqualToAnchor:_wrapInputView.topAnchor],
                [_inputTextField.bottomAnchor constraintEqualToAnchor:_wrapInputView.bottomAnchor],
                [_inputTextField.trailingAnchor constraintEqualToAnchor:_wrapInputView.trailingAnchor constant:-12]
        ]];
    }
    return _inputTextField;
}

- (void)sendBizText:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        NSString *input = textField.text;
//            input = @"";
        if (self.completion) {
            self.completion(input);
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end