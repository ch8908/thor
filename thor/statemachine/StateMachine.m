//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "StateMachine.h"
#import "AbstractState.h"
#import "UserLoginState.h"
#import "UserStateTrigger.h"

NSString *const MachineLoginSuccessNotification = @"MachineLoginSuccessNotification";
NSString *const MachineLogoutNotification = @"MachineLogoutNotification";

@implementation StateMachine

- (id) initWithState:(AbstractState *) initState
{
    self = [super init];
    if (self)
    {
        _currentState = initState;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTransitTo:)
                                                     name:AbstractStateTransitToStateNotification object:nil];
    }

    return self;
}

- (void) onTransitTo:(NSNotification *) notification
{
    AbstractState *state = notification.object;
    [self changeState:state];
}

- (BOOL) isLogin
{
    if ([self.currentState isKindOfClass:[UserLoginState class]])
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

- (void) trigger:(UserStateTrigger *) trigger
{
    [self.currentState trigger:trigger];
}

@end