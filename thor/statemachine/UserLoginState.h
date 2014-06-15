//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractState.h"


@interface UserLoginState : AbstractState
- (id) initWithToken:(NSString *) token pref:(Pref *) pref;
@end