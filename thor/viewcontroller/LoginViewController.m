//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AbstractUIViewController.h"
#import "LoginViewController.h"
#import "Views.h"
#import "I18N.h"
#import "UIColor+Constant.h"
#import "SignUpViewController.h"
#import "CoffeeService.h"
#import "NSString+Util.h"

@interface LoginViewController()<UITextFieldDelegate>
@property (nonatomic) UIButton* signInWithFacebookButton;
@property (nonatomic) UIButton* signInWithTwitterButton;
@property (nonatomic) UIButton* signUpButton;
@property (nonatomic) UITextField* emailField;
@property (nonatomic) UITextField* passwordField;
@property (nonatomic) UIButton* signInButton;
@end

@implementation LoginViewController

- (id) initLogin
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];

        _signInWithFacebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _signInWithTwitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        _signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.signInButton addTarget:self action:@selector(onSubmit)
                    forControlEvents:UIControlEventTouchUpInside];

        CGRect rect = CGRectMake(0, 0, 280, 44);
        _emailField = [[UITextField alloc] initWithFrame:rect];
        self.emailField.delegate = self;
        self.emailField.placeholder = [I18N key:@"enter_email_placeholder"];
        self.emailField.backgroundColor = [UIColor inputFiendBgColor];

        _passwordField = [[UITextField alloc] initWithFrame:rect];
        self.passwordField.delegate = self;
        self.passwordField.placeholder = [I18N key:@"enter_password_placeholder"];
        self.passwordField.backgroundColor = [UIColor inputFiendBgColor];

        [self.signUpButton addTarget:self action:@selector(onSignUp)
                    forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(onCancel)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(onViewTap)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [Views alignCenter:self.emailField containerWidth:self.view.bounds.size.width];
    [Views locate:self.emailField y:self.topBarOffset + 20];
    [Views alignCenter:self.passwordField containerWidth:self.view.bounds.size.width];
    [Views locate:self.passwordField y:[Views bottomOf:self.emailField]];

    [self.signInButton setTitle:[I18N key:@"sign_in_button_title"] forState:UIControlStateNormal];
    [self.signInButton sizeToFit];

    [Views alignCenter:self.signInButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signInButton y:[Views bottomOf:self.passwordField] + 10];

    [self.signInWithFacebookButton setTitle:[I18N key:@"log_in_with_facebook"] forState:UIControlStateNormal];
    self.signInWithFacebookButton.backgroundColor = [UIColor facebookLoginButtonBgColor];
    [Views resize:self.signInWithFacebookButton containerSize:CGSizeMake(260, 50)];
    [Views alignCenter:self.signInWithFacebookButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signInWithFacebookButton y:[Views bottomOf:self.signInButton] + 10];

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

    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.signInButton];
    [self.view addSubview:self.signInWithFacebookButton];
    [self.view addSubview:self.signInWithTwitterButton];
    [self.view addSubview:self.signUpButton];
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [self onViewTap];
    return YES;
}

- (void) onSubmit
{
    NSString* email = self.emailField.text;
    NSString* password = self.passwordField.text;

    if (![NSString isEmptyAfterTrim:email] && ![NSString isEmptyAfterTrim:password])
    {
        [[CoffeeService sharedInstance] signInWithEmail:email password:password];
    }
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
    SignUpViewController* viewController = [[SignUpViewController alloc] initSignUpViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end