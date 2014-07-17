//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "UserStateMachine.h"
#import "AbstractState.h"
#import "UserStateTrigger.h"

NSString *const StateMachineLoginSuccessNotification = @"StateMachineLoginSuccessNotification";
NSString *const StateMachineLogoutNotification = @"StateMachineLogoutNotification";

@implementation UserStateMachine

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