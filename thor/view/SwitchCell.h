//
// Created by Huang ChienShuo on 3/17/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SwitchCell : UITableViewCell
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, strong) UILabel *titleLabel;

- (id) initWithReuseIdentifier:(NSString *) reuseIdentifier;

+ (CGFloat) cellHeight;
@end