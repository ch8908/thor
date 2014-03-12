//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "LogoutState.h"
#import "LogStateMachine.h"


@implementation LogoutState

- (void) enter
{
    NSLog(@"Log: enter:%@", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] postNotificationName:MachineLogoutNotification object:nil];
}

- (void) execute
{
}

- (void) exit
{
    NSLog(@"Log: exit:%@", NSStringFromClass([self class]));
}

@end