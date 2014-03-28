//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 oSolve. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Bolts/BFTask.h>
#import "AbstractUIViewController.h"
#import "LoginViewController.h"
#import "Views.h"
#import "I18N.h"
#import "UIColor+Constant.h"
#import "SignUpViewController.h"
#import "CoffeeService.h"
#import "NSString+Util.h"
#import "Pref.h"
#import "LogStateMachine.h"
#import "LoginState.h"

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

    [Views resize:self.errorMessageLabel containerSize:CGSizeMake(300, 50)];
    [Views alignCenter:self.errorMessageLabel containerWidth:self.view.bounds.size.width];
    [Views locate:self.errorMessageLabel y:self.topBarOffset + 5];

    [Views alignCenter:self.emailField containerWidth:self.view.bounds.size.width];
    [Views locate:self.emailField y:[Views bottomOf:self.errorMessageLabel] + 5];

    [Views alignCenter:self.passwordField containerWidth:self.view.bounds.size.width];
    [Views locate:self.passwordField y:[Views bottomOf:self.emailField] + 5];

    [self.logInButton setTitle:[I18N key:@"log_in_button_title"] forState:UIControlStateNormal];
    [self.logInButton sizeToFit];

    [Views alignCenter:self.logInButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.logInButton y:[Views bottomOf:self.passwordField] + 10];

    [self.signInWithFacebookButton setTitle:[I18N key:@"log_in_with_facebook"] forState:UIControlStateNormal];
    self.signInWithFacebookButton.backgroundColor = [UIColor facebookLoginButtonBgColor];
    [Views resize:self.signInWithFacebookButton containerSize:CGSizeMake(260, 50)];
    [Views alignCenter:self.signInWithFacebookButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signInWithFacebookButton y:[Views bottomOf:self.logInButton] + 20];

    [self.signInWithTwitterButton setTitle:[I18N key:@"log_in_with_twitter"] forState:UIControlStateNormal];
    self.signInWithTwitterButton.backgroundColor = [UIColor twitterLoginButtonBgColor];
    [Views resize:self.signInWithTwitterButton containerSize:CGSizeMake(260, 50)];
    [Views alignCenter:self.signInWithTwitterButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signInWithTwitterButton y:[Views bottomOf:self.signInWithFacebookButton]];

    [self.signUpButton setTitle:[I18N key:@"sign_up"] forState:UIControlStateNormal];
    [Views resize:self.signUpButton containerSize:CGSizeMake(260, 50)];
    [Views alignCenter:self.signUpButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signUpButton y:[Views bottomOf:self.signInWithTwitterButton]];

    [Views alignCenter:self.emailField containerWidth:self.view.bounds.size.width];
    [Views alignCenter:self.passwordField containerWidth:self.view.bounds.size.width];
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
                         NSString *token = task.result;
                         [[[Pref sharedInstance] authenticationToken] setString:token];
                         [[LogStateMachine sharedInstance] changeState:[[LoginState alloc] init]];
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