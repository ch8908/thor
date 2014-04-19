//
// Created by Huang ChienShuo on 3/17/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "SwitchCell.h"
#import "OSViewHelper.h"


@implementation SwitchCell

- (id) initWithReuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _switchButton = [[UISwitch alloc] init];
        _titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
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

    [OSViewHelper resize:self.titleLabel containerSize:CGSizeMake(120, [SwitchCell cellHeight] - 6)];
    [OSViewHelper locate:self.titleLabel x:3];
    [OSViewHelper alignMiddle:self.titleLabel containerHeight:[OSViewHelper heightOfView:self]];

    [OSViewHelper resize:self.switchButton containerSize:CGSizeMake(150, [SwitchCell cellHeight] - 6)];
    [OSViewHelper locate:self.switchButton x:[OSViewHelper rightOf:self.titleLabel] + 3];
    [OSViewHelper alignMiddle:self.switchButton containerHeight:[OSViewHelper heightOfView:self]];

    [self addSubview:self.titleLabel];
    [self addSubview:self.switchButton];
}

@end