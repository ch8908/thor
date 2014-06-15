//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "SignUpViewController.h"
#import "OSViewHelper.h"
#import "UIColor+Constant.h"
#import "I18N.h"
#import "NSString+Util.h"
#import "CoffeeService.h"
#import "UIViewController+Beans.h"
#import "Beans.h"

@interface SignUpViewController()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;
@property (nonatomic, assign) CGFloat viewAndKeyboardOffset;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *errorMessageLabel;
@end

@implementation SignUpViewController

- (id) initSignUpViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }

    return self;
}

- (void) loadView {
    [super loadView];

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
    self.errorMessageLabel.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.confirmPasswordField];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.errorMessageLabel];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor loginViewBgColor];

    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(onViewTap)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.emailField.backgroundColor = [UIColor inputFieldBgColor];
    self.passwordField.backgroundColor = [UIColor inputFieldBgColor];
    self.confirmPasswordField.backgroundColor = [UIColor inputFieldBgColor];

    [OSViewHelper alignCenter:self.emailField containerWidth:self.view.bounds.size.width];
    [OSViewHelper alignCenter:self.passwordField containerWidth:self.view.bounds.size.width];
    [OSViewHelper alignCenter:self.confirmPasswordField containerWidth:self.view.bounds.size.width];

    [OSViewHelper locate:self.emailField y:self.topBarOffset + 64];
    [OSViewHelper locate:self.passwordField y:[OSViewHelper bottomOf:self.emailField] + 5];
    [OSViewHelper locate:self.confirmPasswordField y:[OSViewHelper bottomOf:self.passwordField] + 5];

    [self.submitButton setTitle:[I18N key:@"register_button_title"] forState:UIControlStateNormal];
    [self.submitButton sizeToFit];
    [OSViewHelper resize:self.submitButton containerHeight:44];

    [OSViewHelper alignCenter:self.submitButton containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.submitButton y:[OSViewHelper bottomOf:self.confirmPasswordField] + 10];

    [OSViewHelper resize:self.errorMessageLabel
           containerSize:CGSizeMake([OSViewHelper widthOfView:self.view] - 10, 50)];
    [OSViewHelper alignCenter:self.errorMessageLabel containerWidth:[OSViewHelper widthOfView:self.view]];
    [OSViewHelper locate:self.errorMessageLabel
                       y:[OSViewHelper yOfView:self.emailField] - [OSViewHelper heightOfView:self.errorMessageLabel] - 5];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    [UIView animateWithDuration:duration animations:^{
        [OSViewHelper locate:self.view y:self.view.frame.origin.y];
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y + self.viewAndKeyboardOffset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    }];
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat diff = endFrame.origin.y - (self.confirmPasswordField.frame.origin.y + self.confirmPasswordField.bounds.size.height + self.view.frame.origin.y);
    if (diff > 0) {
        return;
    }
    self.viewAndKeyboardOffset = (CGFloat) fabs(diff) + 5;
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y - self.viewAndKeyboardOffset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    }];
}

- (void) onSubmit {
    ServiceRegisterSource *source = [[ServiceRegisterSource alloc] init];
    source.email = self.emailField.text;
    source.password = self.passwordField.text;
    source.confirmPassword = self.confirmPasswordField.text;

    __weak SignUpViewController *preventCircularRef = self;
    [[self.beans.coffeeService resisterWithParams:source]
                               continueWithBlock:^id(BFTask *task) {
                                   if (task.error) {
                                       preventCircularRef.errorMessageLabel.text = task.error.localizedDescription;
                                       return nil;
                                   }
                                   return nil;
                               }];
}

- (void) onViewTap {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string {
    if ([string stringByTrim].length > 0) {
        self.errorMessageLabel.text = @"";
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end