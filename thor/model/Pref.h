//
// Created by liq on 12/24/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Pref : NSObject
+ (id) sharedInstance;

- (void) setDeviceToken:(NSString*) token;

- (NSString*) deviceToken;

- (void) setAuthenticationToken:(NSString*) token;

- (NSString*) authenticationToken;
@end