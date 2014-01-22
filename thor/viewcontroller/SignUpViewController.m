//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "SignUpViewController.h"
#import "Views.h"
#import "UIColor+Constant.h"
#import "I18N.h"
#import "NSString+Util.h"
#import "CoffeeService.h"

@interface SignUpViewController()<UITextFieldDelegate>
@property (nonatomic) UITextField* emailField;
@property (nonatomic) UITextField* passwordField;
@property (nonatomic) UITextField* confirmPasswordField;
@property (nonatomic) CGFloat viewAndKeyboardOffset;
@property (nonatomic) UIButton* submitButton;
@property (nonatomic) UILabel* errorMessageLabel;
@end

@implementation SignUpViewController

- (id) initSignUpViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor loginViewBgColor];
        CGRect rect = CGRectMake(0, 0, 280, 44);
        _emailField = [[UITextField alloc] initWithFrame:rect];
        self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailField.delegate = self;
        self.emailField.placeholder = [I18N key:@"enter_email_placeholder"];

        _passwordField = [[UITextField alloc] initWithFrame:rect];
        self.passwordField.secureTextEntry = YES;
        self.passwordField.delegate = self;
        self.passwordField.placeholder = [I18N key:@"enter_password_placeholder"];

        _confirmPasswordField = [[UITextField alloc] initWithFrame:rect];
        self.confirmPasswordField.secureTextEntry = YES;
        self.confirmPasswordField.delegate = self;
        self.confirmPasswordField.placeholder = [I18N key:@"confirm_password_placeholder"];

        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.submitButton addTarget:self action:@selector(onSubmit)
                    forControlEvents:UIControlEventTouchUpInside];

        _errorMessageLabel = [[UILabel alloc] init];
        self.errorMessageLabel.textColor = [UIColor redColor];
        self.errorMessageLabel.backgroundColor = [UIColor clearColor];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRegisterFailedNotification:)
                                                     name:RegisterFailedNotification
                                                   object:nil];
    }

    return self;
}

- (void) onRegisterFailedNotification:(NSNotification*) notification
{
    NSString* errorMessage = notification.object;
    self.errorMessageLabel.text = errorMessage;
    [self.errorMessageLabel sizeToFit];
    [Views alignCenter:self.errorMessageLabel containerWidth:self.view.bounds.size.width];
    [Views locate:self.errorMessageLabel y:self.topBarOffset + 10];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(onViewTap)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.emailField.backgroundColor = [UIColor inputFiendBgColor];
    self.passwordField.backgroundColor = [UIColor inputFiendBgColor];
    self.confirmPasswordField.backgroundColor = [UIColor inputFiendBgColor];

    [Views alignCenter:self.emailField containerWidth:self.view.bounds.size.width];
    [Views alignCenter:self.passwordField containerWidth:self.view.bounds.size.width];
    [Views alignCenter:self.confirmPasswordField containerWidth:self.view.bounds.size.width];

    [Views locate:self.emailField y:self.topBarOffset + 64];
    [Views locate:self.passwordField y:[Views bottomOf:self.emailField] + 5];
    [Views locate:self.confirmPasswordField y:[Views bottomOf:self.passwordField] + 5];

    [self.submitButton setTitle:[I18N key:@"register_button_title"] forState:UIControlStateNormal];
    [self.submitButton sizeToFit];
    [Views resize:self.submitButton containerHeight:44];

    [Views alignCenter:self.submitButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.submitButton y:[Views bottomOf:self.confirmPasswordField] + 10];

    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.confirmPasswordField];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.errorMessageLabel];
}

- (void) keyboardWillHide:(NSNotification*) notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    [UIView animateWithDuration:duration animations:^{
        [Views locate:self.view y:self.view.frame.origin.y];
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y + self.viewAndKeyboardOffset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    }];
}

- (void) keyboardWillShow:(NSNotification*) notification
{
    NSDictionary* info = [notification userInfo];
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat diff = endFrame.origin.y - (self.confirmPasswordField.frame.origin.y + self.confirmPasswordField.bounds.size.height + self.view.frame.origin.y);
    if (diff > 0)
    {
        return;
    }
    self.viewAndKeyboardOffset = (CGFloat) fabs(diff) + 5;
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y - self.viewAndKeyboardOffset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    }];
}

- (void) onSubmit
{
    NSString* email = self.emailField.text;
    NSString* password = self.passwordField.text;
    NSString* confirmPassword = self.confirmPasswordField.text;

    if ([NSString isEmptyAfterTrim:email] && [NSString isEmptyAfterTrim:password] && [NSString isEmptyAfterTrim:confirmPassword])
    {
        return;
    }

    if (![password isEqualToString:confirmPassword])
    {
        return;
    }

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [params setObject:confirmPassword forKey:@"password_confirmation"];
    [[CoffeeService sharedInstance] resisterWithParams:[params copy]];
}

- (void) onViewTap
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
}

- (BOOL) textField:(UITextField*) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString*) string
{
    if ([string stringByTrim].length > 0)
    {
        self.errorMessageLabel.text = @"";
    }
    return YES;
}

@end