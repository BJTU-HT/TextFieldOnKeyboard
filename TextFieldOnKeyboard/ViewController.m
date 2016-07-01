//
//  ViewController.m
//  TextFieldOnKeyboard
//
//  Created by tom555cat on 16/7/1.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 测试按钮
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    testBtn.backgroundColor = [UIColor redColor];
    [testBtn addTarget:self action:@selector(popInputField) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    // 键盘上方的输入框
    CGFloat W = self.view.frame.size.width;
    CGFloat H = 40;
    CGFloat X = 0;
    CGFloat Y = self.view.frame.size.height + H;
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    self.inputField.backgroundColor = [UIColor orangeColor];
    self.inputField.hidden = YES;
    self.inputField.delegate = self;
    [self.view addSubview:self.inputField];
}

- (void)popInputField
{
    if (self.inputField.hidden) {
        [self.inputField becomeFirstResponder];
    } else {
        [self.inputField resignFirstResponder];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark ---------- UITextFieldDelegate -------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputField resignFirstResponder];
    return YES;
}

#pragma mark ---------- keyboard event ------------
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info
{
    // 获取键盘的弹出动画
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    // 为self.inputField创建动画
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    
    // 把键盘动画合并到inputField动画上
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    
    // 获取键盘动画的持续时间
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 通过获取键盘frame来获取键盘的高度
    NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    if (showKeyboard) {
        // 设置弹出self.inputField动画
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            self.inputField.hidden = NO;
            CGFloat W = self.view.frame.size.width;
            CGFloat H = 40;
            CGFloat X = 0;
            CGFloat Y = self.view.frame.size.height - keyboardHeight - H;
            self.inputField.frame = CGRectMake(X, Y, W, H);
        } completion:nil];
    } else {
        // 设置收回self.inputField动画
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            CGFloat W = self.view.frame.size.width;
            CGFloat H = 40;
            CGFloat X = 0;
            CGFloat Y = self.view.frame.size.height;
            self.inputField.frame = CGRectMake(X, Y, W, H);
            self.inputField.hidden = YES;
        } completion:nil];
    }

}

@end
