//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PopupViewController.h"
#import "I18N.h"
#import "Views.h"


@interface PopupViewController()

@end

@implementation PopupViewController
@synthesize delegate = _delegate;
@synthesize submitButton = _submitButton;
@synthesize titleLabel = _titleLabel;

- (id) initWithPopup
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        CGRect popupViewFrame = CGRectMake(0, 0, 200, 300);
        self.view.frame = popupViewFrame;
        self.view.backgroundColor = [UIColor whiteColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, popupViewFrame.size.width, 80)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:_titleLabel];

        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_submitButton setTitle:[I18N key:@"submit_button_title"] forState:UIControlStateNormal];
        _submitButton.frame = CGRectMake(0, 0, 100, 50);
        [_submitButton addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
        [Views alignCenter:_submitButton containerWidth:self.view.bounds.size.width];
        [Views locate:_submitButton y:[Views bottomOf:self.view] - _submitButton.bounds.size.height - 5];
        [self.view addSubview:_submitButton];
    }

    return self;
}

- (void) submitComment
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitButtonClicked:)])
    {
        [self.delegate submitButtonClicked:self];
    }
}

@end