//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 oSolve. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Bolts/BFTask.h>
#import "AbstractUIViewController.h"
#import "LoginViewController.h"
#import "OSViewHelper.h"
#import "I18N.h"
#import "UIColor+Constant.h"
#import "SignUpViewController.h"
#import "CoffeeService.h"
#import "NSString+Util.h"
#import "Pref.h"
#import "StateMachine.h"
#import "UserLoginState.h"

@interface LoginViewController()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *signInWithFacebookButton;
@property (nonatomic, strong) UIButton *signInWithTwitterButton;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *logInButton;
@property (nonatomic, strong) UILabel *errorMessageLabel;
@end

@implementation LoginViewController

- (id) initLogin
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
    }

    return self;
}

- (void) loadView
{
    [super loadView];

    _signInWithFacebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _signInWithTwitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    _logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.logInButton addTarget:self action:@selector(onSubmit)
               forControlEvents:UIControlEventTouchUpInside];

    CGRect rect = CGRectMake(0, 0, 280, 44);
    _emailField = [[UITextField alloc] initWithFrame:rect];
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.delegate = self;
    self.emailField.placeholder = [I18N key:@"enter_email_placeholder"];
    self.emailField.backgroundColor = [UIColor inputFieldBgColor];

    _passwordField = [[UITextField alloc] initWithFrame:rect];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    self.passwordField.placeholder = [I18N key:@"enter_password_placeholder"];
    self.passwordField.backgroundColor = [UIColor inputFieldBgColor];

    _errorMessageLabel = [[UILabel alloc] init];
    self.errorMessageLabel.textColor = [UIColor redColor];
    self.errorMessageLabel.backgroundColor = [UIColor clearColor];
    self.errorMessageLabel.numberOfLines = 2;
    self.errorMessageLabel.textAlignment = NSTextAlignmentCenter;

    [self.signUpButton addTarget:self action:@selector(onSignUp)
                forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.errorMessageLabel];
    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.logInButton];
    [self.view addSubview:self.signInWithFacebookButton];
    [self.view addSubview:self.signInWithTwitterButton];
    [self.view addSubview:self.signUpButton];
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor loginViewBgColor];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(onCancel)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(onViewTap)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [OSViewHelper resize:self.errorMessageLabel containerSize:CGSizeMake(300, 50)];
    [OSViewHelper alignCenter:self.errorMessageLabel containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.errorMessageLabel y:self.topBarOffset + 5];

    [OSViewHelper alignCenter:self.emailField containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.emailField y:[OSViewHelper bottomOf:self.errorMessageLabel] + 5];

    [OSViewHelper alignCenter:self.passwordField containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.passwordField y:[OSViewHelper bottomOf:self.emailField] + 5];

    [self.logInButton setTitle:[I18N key:@"log_in_button_title"] forState:UIControlStateNormal];
    [self.logInButton sizeToFit];

    [OSViewHelper alignCenter:self.logInButton containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.logInButton y:[OSViewHelper bottomOf:self.passwordField] + 10];

    [self.signInWithFacebookButton setTitle:[I18N key:@"log_in_with_facebook"] forState:UIControlStateNormal];
    self.signInWithFacebookButton.backgroundColor = [UIColor facebookLoginButtonBgColor];
    [OSViewHelper resize:self.signInWithFacebookButton containerSize:CGSizeMake(260, 50)];
    [OSViewHelper alignCenter:self.signInWithFacebookButton containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.signInWithFacebookButton y:[OSViewHelper bottomOf:self.logInButton] + 20];

    [self.signInWithTwitterButton setTitle:[I18N key:@"log_in_with_twitter"] forState:UIControlStateNormal];
    self.signInWithTwitterButton.backgroundColor = [UIColor twitterLoginButtonBgColor];
    [OSViewHelper resize:self.signInWithTwitterButton containerSize:CGSizeMake(260, 50)];
    [OSViewHelper alignCenter:self.signInWithTwitterButton containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.signInWithTwitterButton y:[OSViewHelper bottomOf:self.signInWithFacebookButton]];

    [self.signUpButton setTitle:[I18N key:@"sign_up"] forState:UIControlStateNormal];
    [OSViewHelper resize:self.signUpButton containerSize:CGSizeMake(260, 50)];
    [OSViewHelper alignCenter:self.signUpButton containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.signUpButton y:[OSViewHelper bottomOf:self.signInWithTwitterButton]];

    [OSViewHelper alignCenter:self.emailField containerWidth:self.view.bounds.size.width];
    [OSViewHelper alignCenter:self.passwordField containerWidth:self.view.bounds.size.width];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    [self onViewTap];
    return YES;
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string
{
    if ([string stringByTrim].length > 0)
    {
        self.errorMessageLabel.text = @"";
    }
    return YES;
}

- (void) onSubmit
{
    ServiceLoginSource *source = [[ServiceLoginSource alloc] init];
    source.email = self.emailField.text;
    source.password = self.passwordField.text;

    __weak LoginViewController *preventCircularRef = self;
    [[[CoffeeService sharedInstance] loginWithSource:source]
                     continueWithBlock:^id(BFTask *task) {
                         if (task.error)
                         {
                             preventCircularRef.errorMessageLabel.text = task.error.localizedDescription;
                             return nil;
                         }
                         [preventCircularRef onCancel];
                         return nil;
                     }];
}

- (void) onCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) onViewTap
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void) onSignUp
{
    SignUpViewController *viewController = [[SignUpViewController alloc] initSignUpViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end