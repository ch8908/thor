//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PopupViewController;

@protocol PopupSubmitDelegate<NSObject>
@optional
- (void) submitButtonClicked:(PopupViewController*) secondDetailViewController;
@end

@interface PopupViewController : UIViewController
{
    CGFloat viewAndKeyboardOffset;

}
@property (nonatomic, assign) id<PopupSubmitDelegate> delegate;
@property (nonatomic) UIButton* submitButton;
@property (nonatomic) UILabel* titleLabel;

- (id) initWithPopup;

@end