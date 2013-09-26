//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginViewController.h"
#import "Views.h"
#import "I18N.h"

@interface LoginViewController()
@property (nonatomic) UIButton* signInWithFacebookButton;
@property (nonatomic) UIButton* signInWithTwitterButton;
@property (nonatomic) UIButton* signUpButton;
@end

@implementation LoginViewController
@synthesize signInWithFacebookButton = _signInWithFacebookButton;
@synthesize signInWithTwitterButton = _signInWithTwitterButton;
@synthesize signUpButton = _signUpButton;

- (id) initLogin
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];

        _signInWithFacebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_signInWithFacebookButton setTitle:[I18N key:@"log_in_with_facebook"] forState:UIControlStateNormal];
        [Views resize:_signInWithFacebookButton containerSize:CGSizeMake(260, 50)];
        [Views alignCenter:_signInWithFacebookButton containerWidth:self.view.bounds.size.width];
        [self.view addSubview:_signInWithFacebookButton];

        _signInWithTwitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_signInWithFacebookButton setTitle:[I18N key:@"log_in_with_twitter"] forState:UIControlStateNormal];
        [Views resize:_signInWithTwitterButton containerSize:CGSizeMake(260, 50)];
        [Views alignCenter:_signInWithTwitterButton containerWidth:self.view.bounds.size.width];
        [Views locate:_signInWithTwitterButton y:[Views bottomOf:_signInWithFacebookButton]];
        [self.view addSubview:_signInWithTwitterButton];

        _signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_signInWithFacebookButton setTitle:[I18N key:@"sign_up"] forState:UIControlStateNormal];
        [Views resize:_signUpButton containerSize:CGSizeMake(260, 50)];
        [Views alignCenter:_signUpButton containerWidth:self.view.bounds.size.width];
        [Views locate:_signUpButton y:[Views bottomOf:_signInWithTwitterButton]];
        [self.view addSubview:_signUpButton];

        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(onCancel)];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
    }

    return self;
}

- (void) onCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end