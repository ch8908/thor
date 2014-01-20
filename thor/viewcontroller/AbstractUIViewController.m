//
// Created by Huang ChienShuo on 1/20/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "AbstractUIViewController.h"
#import "System.h"


@implementation AbstractUIViewController

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([System isMinimumiOS7])
    {
        self.topBarOffset = self.topLayoutGuide.length;
    }
}

@end