//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PopupViewController.h"
#import "I18N.h"
#import "Views.h"
#import "NSString+Util.h"

@interface PopupViewController()<UITextFieldDelegate>
@property (nonatomic) UITextField* textField;
@property (nonatomic) UILabel* warningLabel;
@property (nonatomic) UITapGestureRecognizer* singleTapGestureRecognizer;
@end

@implementation PopupViewController
@synthesize delegate = _delegate;
@synthesize submitButton = _submitButton;
@synthesize titleLabel = _titleLabel;
@synthesize textField = _textField;
@synthesize singleTapGestureRecognizer = _singleTapGestureRecognizer;
@synthesize warningLabel = _warningLabel;

- (id) initWithPopup
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        CGRect popupViewFrame = CGRectMake(0, 0, self.view.bounds.size.width - 40, 300);
        self.view.frame = popupViewFrame;
        self.view.backgroundColor = [UIColor whiteColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, popupViewFrame.size.width, 36)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:_titleLabel];

        _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, popupViewFrame.size.width, 20)];
        _warningLabel.textAlignment = NSTextAlignmentCenter;
        _warningLabel.textColor = [UIColor redColor];
        _warningLabel.backgroundColor = [UIColor clearColor];
        _warningLabel.font = [UIFont systemFontOfSize:16];
        [Views locate:_warningLabel y:[Views bottomOf:_titleLabel]];
        [self.view addSubview:_warningLabel];

        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, popupViewFrame.size.width - 20, 140)];
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor lightGrayColor];
        [Views alignCenter:_textField containerWidth:popupViewFrame.size.width];
        [Views locate:_textField y:[Views bottomOf:_warningLabel]];
        [self.view addSubview:_textField];

        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_submitButton setTitle:[I18N key:@"submit_button_title"] forState:UIControlStateNormal];
        _submitButton.frame = CGRectMake(0, 0, popupViewFrame.size.width - 20, 44);
        [_submitButton addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
        [Views alignCenter:_submitButton containerWidth:self.view.bounds.size.width];
        [Views locate:_submitButton y:[Views bottomOf:_textField] + 10];
        [self.view addSubview:_submitButton];

        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onViewTap)];
        [self.view addGestureRecognizer:_singleTapGestureRecognizer];
    }

    return self;
}

- (void) onViewTap
{
    if (self.textField.isEditing)
    {
        [self.textField resignFirstResponder];
        [self.view removeGestureRecognizer:self.singleTapGestureRecognizer];
    }
}

- (void) submitComment
{
    NSString* comments = self.textField.text;

    if ([comments stringByTrim].length == 0)
    {
        self.warningLabel.text = [I18N key:@"comment_cannot_be_none"];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(submitButtonClicked:)])
    {
        [self.delegate submitButtonClicked:self];
    }
}

- (void) removeTextFieldDelegate
{
    self.textField.delegate = nil;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField*) textField
{
    [self.view addGestureRecognizer:self.singleTapGestureRecognizer];
    return YES;
}

- (BOOL) textField:(UITextField*) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString*) string
{
    if ([string stringByTrim].length > 0)
    {
        self.warningLabel.text = @"";
    }
    return YES;
}


- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [self.textField resignFirstResponder];
    return NO;
}


@end