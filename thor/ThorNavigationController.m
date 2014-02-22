//
// Created by Huang ChienShuo on 10/5/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ThorNavigationController.h"


@implementation ThorNavigationController

- (id) initWithRootViewController:(UIViewController *) rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        self.navigationBar.translucent = NO;
    }

    return self;
}


@end