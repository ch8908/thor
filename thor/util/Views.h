//
// Created by Huang ChienShuo on 9/8/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Views : NSObject
+ (void) locate:(UIView*) target x:(CGFloat) x y:(CGFloat) y;

+ (void) locate:(UIView*) target y:(CGFloat) y;

+ (void) locate:(UIView*) target x:(CGFloat) x;

+ (CGFloat) rightOf:(UIView*) view;

+ (CGFloat) bottomOf:(UIView*) view;

+ (void) alignCenter:(UIView*) target containerWidth:(CGFloat) containerWidth;

+ (void) alignCenterMiddle:(UIView*) target containerFrame:(CGRect) frameRect;

+ (void) alignMiddle:(UIView*) target containerHeight:(CGFloat) containerHeight;

+ (void) alignBottom:(UIView*) source withTarget:(UIView*) target;

+ (void) alignMiddle:(UIView*) source withTarget:(UIView*) target;

+ (void) resize:(UIView*) target containerSize:(CGSize) size;

+ (void) resize:(UIView*) target containerWidth:(CGFloat) containerWidth;

+ (void) resize:(UIView*) target containerHeight:(CGFloat) containerHeight;
@end