//
// Created by Huang ChienShuo on 3/16/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "TextFieldCell.h"
#import "OSViewHelper.h"
#import "UIColor+Constant.h"


CGFloat const TITLE_LABEL_WIDTH = 80;
CGFloat const TEXT_FIELD_X_PADDING = 5;

@implementation TextFieldCell

- (id) initTextFieldCellWithReuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;

        _inputField = [[UITextField alloc] init];
        self.inputField.backgroundColor = [UIColor inputFieldBgColor];

        _inputFieldTitleLabel = [[UILabel alloc] init];
        self.inputFieldTitleLabel.backgroundColor = [UIColor whiteColor];
        self.inputFieldTitleLabel.font = [UIFont systemFontOfSize:12];
        self.inputFieldTitleLabel.textColor = [UIColor lightGrayColor];
        self.inputFieldTitleLabel.numberOfLines = 0;
    }

    return self;
}

+ (CGFloat) cellHeight
{
    return 60;
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    // Title Label
    [OSViewHelper resize:self.inputFieldTitleLabel
           containerSize:CGSizeMake([OSViewHelper widthOfView:self], 20)];

    [OSViewHelper locate:self.inputFieldTitleLabel x:TEXT_FIELD_X_PADDING y:0];

    // Input TextField
    [OSViewHelper resize:self.inputField
           containerSize:CGSizeMake([OSViewHelper widthOfView:self] - TEXT_FIELD_X_PADDING * 2,
                                    [OSViewHelper heightOfView:self] - [OSViewHelper bottomOf:self.inputFieldTitleLabel])];

    [OSViewHelper locate:self.inputField x:TEXT_FIELD_X_PADDING
                       y:[OSViewHelper bottomOf:self.inputFieldTitleLabel]];

    [self addSubview:self.inputFieldTitleLabel];
    [self addSubview:self.inputField];
}

@end