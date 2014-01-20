//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginViewController.h"
#import "Views.h"
#import "I18N.h"
#import "UIColor+Constant.h"
#import "SignUpViewController.h"

@interface LoginViewController()
@property (nonatomic) UIButton* signInWithFacebookButton;
@property (nonatomic) UIButton* signInWithTwitterButton;
@property (nonatomic) UIButton* signUpButton;
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
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self.signInWithFacebookButton setTitle:[I18N key:@"log_in_with_facebook"] forState:UIControlStateNormal];
    self.signInWithFacebookButton.backgroundColor = [UIColor facebookLoginButtonBgColor];
    [Views resize:self.signInWithFacebookButton containerSize:CGSizeMake(260, 50)];
    [Views alignCenter:self.signInWithFacebookButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signInWithFacebookButton y:100];
    [self.view addSubview:self.signInWithFacebookButton];

    [self.signInWithTwitterButton setTitle:[I18N key:@"log_in_with_twitter"] forState:UIControlStateNormal];
    self.signInWithTwitterButton.backgroundColor = [UIColor twitterLoginButtonBgColor];
    [Views resize:self.signInWithTwitterButton containerSize:CGSizeMake(260, 50)];
    [Views alignCenter:self.signInWithTwitterButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signInWithTwitterButton y:[Views bottomOf:self.signInWithFacebookButton]];
    [self.view addSubview:self.signInWithTwitterButton];

    [self.signUpButton setTitle:[I18N key:@"sign_up"] forState:UIControlStateNormal];
    [Views resize:self.signUpButton containerSize:CGSizeMake(260, 50)];
    [Views alignCenter:self.signUpButton containerWidth:self.view.bounds.size.width];
    [Views locate:self.signUpButton y:[Views bottomOf:self.signInWithTwitterButton]];
    [self.view addSubview:self.signUpButton];
}

- (void) onCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSignUp
{
    SignUpViewController* viewController = [[SignUpViewController alloc] initSignUpViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end