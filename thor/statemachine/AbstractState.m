//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "AbstractState.h"
#import "UserStateTrigger.h"


NSString *const AbstractStateTransitToStateNotification = @"AbstractStateTransitToStateNotification";

@implementation AbstractState

- (void) transitToState:(AbstractState *) state
{
    [[NSNotificationCenter defaultCenter]
                           postNotificationName:AbstractStateTransitToStateNotification
                                         object:state];
}

- (void) trigger:(UserStateTrigger *) trigger
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void) enter
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void) exit
{
    [self doesNotRecognizeSelector:_cmd];
}

@end