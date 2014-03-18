//
// Created by Huang ChienShuo on 3/16/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextFieldCell : UITableViewCell
@property (nonatomic, strong) UILabel *inputFieldTitleLabel;
@property (nonatomic, strong) UITextField *inputField;

- (id) initTextFieldCellWithReuseIdentifier:(NSString *) reuseIdentifier;

+ (CGFloat) cellHeight;
@end