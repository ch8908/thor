//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "LoginState.h"
#import "LogStateMachine.h"
#import "Pref.h"


@implementation LoginState
- (void) enter
{
    NSLog(@"Log: enter:%@", NSStringFromClass([self class]));
    [[LogStateMachine sharedInstance] setAuthToken:[[[Pref sharedInstance] authenticationToken] getString]];
    [[NSNotificationCenter defaultCenter] postNotificationName:MachineLoginSuccessNotification object:nil];
}

- (void) execute
{
}

- (void) exit
{
    NSLog(@"Log: exit:%@", NSStringFromClass([self class]));
    [[[Pref sharedInstance] authenticationToken] removeString];
}

@end