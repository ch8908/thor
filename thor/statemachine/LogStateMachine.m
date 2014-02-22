//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "LogStateMachine.h"
#import "AbstractState.h"
#import "Pref.h"
#import "LoginState.h"
#import "LogoutState.h"

NSString *MachineLoginSuccessNotification = @"MachineLoginSuccessNotification";
NSString *MachineLogoutNotification = @"MachineLogoutNotification";

@implementation LogStateMachine

+ (id) sharedInstance
{
    static LogStateMachine *sharedMyInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] initLogStateMachine];
    });

    return sharedMyInstance;
}

- (id) initLogStateMachine
{
    NSString *token = [[[Pref sharedInstance] authenticationToken] getString];
    if (token)
    {
        _authToken = token;
        _currentState = [[LoginState alloc] init];
    }
    else
    {
        _currentState = [[LogoutState alloc] init];
    }
    return self;
}

- (BOOL) isLogin
{
    if ([self.currentState isKindOfClass:[LoginState class]])
    {
        return YES;
    }
    return NO;
}

- (void) changeState:(AbstractState *) newState
{
    [self.currentState exit];
    self.currentState = newState;
    [self.currentState enter];
}

@end