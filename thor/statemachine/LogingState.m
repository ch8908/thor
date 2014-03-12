//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "LogingState.h"


@implementation LogingState
- (void) enter
{
    NSLog(@"Log: enter:%@", NSStringFromClass([self class]));
}

- (void) execute
{
}

- (void) exit
{
    NSLog(@"Log: exit:%@", NSStringFromClass([self class]));
}
@end