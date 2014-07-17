//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AbstractState;
@class UserStateTrigger;

extern NSString *const StateMachineLoginSuccessNotification;
extern NSString *const StateMachineLogoutNotification;

@interface UserStateMachine : NSObject
@property (nonatomic, strong) AbstractState *currentState;

- (id) initWithState:(AbstractState *) initState;

- (void) trigger:(UserStateTrigger *) trigger;
@end