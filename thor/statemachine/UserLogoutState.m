//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "UserLogoutState.h"
#import "StateMachine.h"
#import "UserStateTrigger.h"
#import "Pref.h"
#import "NSString+Util.h"
#import "UserLoginState.h"


@implementation UserLogoutState

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

- (void) trigger:(UserStateTrigger *) trigger
{
    if (trigger.checkLogin)
    {
        NSString *token = [[[Pref sharedInstance] authenticationToken] getString];
        if (![NSString isEmptyAfterTrim:token])
        {
            [self transitToState:[[UserLoginState alloc] initWithToken:token]];
        }
    }
    else if (trigger.signIn)
    {
        NSString *token = [[[Pref sharedInstance] authenticationToken] getString];
        if (![NSString isEmptyAfterTrim:token])
        {
            [self transitToState:[[UserLoginState alloc] initWithToken:token]];
        }
    }
}

@end