//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoffeeService;
@class UserStateTrigger;

extern NSString *const AbstractStateTransitToStateNotification;

@interface AbstractState : NSObject

@property (nonatomic) CoffeeService *service;

- (void) transitToState:(AbstractState *) state;

- (void) trigger:(UserStateTrigger *) trigger;

- (void) enter;

- (void) exit;

@end