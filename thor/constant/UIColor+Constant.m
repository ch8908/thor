//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "UIColor+Constant.h"
#import "UIColor+Util.h"


@implementation UIColor(Constant)

+ (UIColor *) addressTextColor
{
    return [UIColor blackColor];
}

+ (UIColor *) facebookLoginButtonBgColor
{
    return [UIColor hexARGB:0xFF3937FF];
}

+ (UIColor *) twitterLoginButtonBgColor
{
    return [UIColor hexARGB:0xFF55A8FF];
}

+ (UIColor *) inputFieldBgColor
{
    return [UIColor hexARGB:0xFF999999];
}

+ (UIColor *) loginViewBgColor
{
    return [UIColor hexARGB:0xFF73FFBB];
}

+ (UIColor *) requiredFieldWarningColor
{
    return [UIColor hexARGB:0xFFFF9291];
}

+ (UIColor *) filterButtonBgColorNormal
{
    return [UIColor hexARGB:0xFF55FFAC];
}

+ (UIColor *) filterButtonBgColorHighlighted
{
    return [UIColor hexARGB:0xFF00DC71];
}

+ (UIColor *) transparentBgColor
{
    return [UIColor hexARGB:0xFF87B8EB];
}

+ (UIColor *) navigationBarTintColor
{
    return [UIColor hexARGB:0x8000FA03];

}

+ (UIColor *) searchViewBgColor
{
    return [UIColor hexARGB:0xC8000000];
}

@end