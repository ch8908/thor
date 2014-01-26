//
// Created by Huang ChienShuo on 1/26/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "UINavigationItem+Util.h"

static CGFloat DURATION = 0.5;

@implementation UINavigationItem(Util)

- (void) setTitleView:(UIView*) titleView animated:(BOOL) animated
{
    if (!animated)
    {
        [self setTitleView:titleView];
        return;
    }

    [self disappearCurrentTitle:^{
        [self showNewTitleView:titleView];
    }];
}

- (void) setTitleViewWithTitle:(NSString*) title animated:(BOOL) animated
{
    if (!animated)
    {
        UILabel* titleView = [self titleViewWithTitle:title];
        [self setTitleView:titleView];
        return;
    }

    [self disappearCurrentTitle:^{
        [self showNewTitleViewWithString:title];
    }];
}

- (void) disappearCurrentTitle:(void (^)(void)) completion
{
    [CATransaction begin];
    CABasicAnimation* fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeOutAnimation.duration = DURATION;
    [fadeOutAnimation setRemovedOnCompletion:YES];
    [self.titleView.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
    [CATransaction setCompletionBlock:^{
        self.titleView.alpha = 0;
        completion();
    }];
    [CATransaction commit];
}

- (void) showNewTitleView:(UIView*) titleView
{
    [self setTitleView:titleView];
    self.titleView.alpha = 0;

    [CATransaction begin];
    CABasicAnimation* fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.duration = DURATION;
    [fadeInAnimation setRemovedOnCompletion:YES];
    [self.titleView.layer addAnimation:fadeInAnimation forKey:@"opacity"];
    [CATransaction setCompletionBlock:^{
        self.titleView.alpha = 1;
    }];
    [CATransaction commit];
}

- (void) showNewTitleViewWithString:(NSString*) title
{
    UILabel* titleView = [self titleViewWithTitle:title];
    [self setTitleView:titleView];
    self.titleView.alpha = 0;

    [CATransaction begin];
    CABasicAnimation* fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.duration = DURATION;
    [fadeInAnimation setRemovedOnCompletion:YES];
    [self.titleView.layer addAnimation:fadeInAnimation forKey:@"opacity"];
    [CATransaction setCompletionBlock:^{
        self.titleView.alpha = 1;
    }];
    [CATransaction commit];
}

- (UILabel*) titleViewWithTitle:(NSString*) title
{
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    return titleLabel;
}

@end