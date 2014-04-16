//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "UserLoginState.h"
#import "StateMachine.h"
#import "Pref.h"
#import "UserStateTrigger.h"
#import "UserLogoutState.h"


@interface UserLoginState()
@property (nonatomic, strong) NSString *authenticationToken;
@end

@implementation UserLoginState

- (id) initWithToken:(NSString *) token
{
    self = [super init];
    if (self)
    {
        _authenticationToken = token;
    }
    return self;
}

- (void) enter
{
    NSLog(@"Log: enter:%@", NSStringFromClass([self class]));
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

- (void) trigger:(UserStateTrigger *) trigger
{
    if (trigger.signOut)
    {
        UserLogoutState *state = [[UserLogoutState alloc] init];
        [self transitToState:state];
    }
}


@end