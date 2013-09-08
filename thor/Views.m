//
// Created by Huang ChienShuo on 9/8/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Views.h"


@implementation Views

+ (void) locate:(UIView*) target x:(CGFloat) x y:(CGFloat) y
{
    CGRect rect = target.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    target.frame = rect;
}

+ (void) locate:(UIView*) target y:(CGFloat) y
{
    CGRect rect = target.frame;
    rect.origin.y = y;
    target.frame = rect;
}

+ (void) locate:(UIView*) target x:(CGFloat) x
{
    CGRect rect = target.frame;
    rect.origin.x = x;
    target.frame = rect;
}

+ (CGFloat) rightOf:(UIView*) view
{
    return view.frame.origin.x + view.frame.size.width;
}

+ (CGFloat) bottomOf:(UIView*) view
{
    return view.frame.origin.y + view.frame.size.height;
}

+ (void) alignCenterMiddle:(UIView*) target containerFrame:(CGRect) frameRect
{
    CGRect rect = target.frame;
    rect.origin.x = roundf(frameRect.origin.x + (frameRect.size.width - rect.size.width) / 2);
    rect.origin.y = roundf(frameRect.origin.y + (frameRect.size.height - rect.size.height) / 2);
    target.frame = rect;
}

+ (void) alignMiddle:(UIView*) target containerHeight:(CGFloat) containerHeight
{
    CGRect rect = target.frame;
    rect.origin.y = roundf((containerHeight - rect.size.height) / 2);
    target.frame = rect;
}

+ (void) alignBottom:(UIView*) source withTarget:(UIView*) target
{
    [self locate:source y:[self bottomOf:target] - source.bounds.size.height];
}

+ (void) alignMiddle:(UIView*) source withTarget:(UIView*) target
{
    [self locate:source y:target.frame.origin.y + (target.bounds.size.height - source.bounds.size.height) * 0.5];
}

+ (void) resize:(UIView*) target containerSize:(CGSize) size
{
    CGRect rect = target.frame;
    rect.size = size;
    target.frame = rect;
}

+ (void) resize:(UIView*) target containerWidth:(CGFloat) containerWidth
{
    CGRect rect = target.frame;
    rect.size = CGSizeMake(containerWidth, rect.size.height);
    target.frame = rect;
}

+ (void) resize:(UIView*) target containerHeight:(CGFloat) containerHeight
{
    CGRect rect = target.frame;
    rect.size = CGSizeMake(rect.size.width, containerHeight);
    target.frame = rect;
}

@end