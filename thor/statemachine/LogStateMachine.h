//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AbstractState;

extern NSString* MachineLoginSuccessNotification;
extern NSString* MachineLogoutNotification;

@interface LogStateMachine : NSObject
@property AbstractState* currentState;
@property NSString* authToken;

+ (id) sharedInstance;

- (BOOL) isLogin;

- (void) changeState:(AbstractState*) newState;

@end