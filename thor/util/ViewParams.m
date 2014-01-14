//
// Created by Huang ChienShuo on 8/21/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ViewParams.h"


@implementation ViewParams

+ (CGFloat) screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat) screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

@end