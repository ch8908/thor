//
// Created by Huang ChienShuo on 3/17/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "SwitchCell.h"
#import "Views.h"


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

    [Views resize:self.titleLabel containerSize:CGSizeMake(120, [SwitchCell cellHeight] - 6)];
    [Views locate:self.titleLabel x:3];
    [Views alignMiddle:self.titleLabel containerHeight:[Views heightOfView:self]];

    [Views resize:self.switchButton containerSize:CGSizeMake(150, [SwitchCell cellHeight] - 6)];
    [Views locate:self.switchButton x:[Views rightOf:self.titleLabel] + 3];
    [Views alignMiddle:self.switchButton containerHeight:[Views heightOfView:self]];

    [self addSubview:self.titleLabel];
    [self addSubview:self.switchButton];
}

@end