//
// Created by liq on 12/24/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import "Pref.h"

NSString *const SearchDistanceChangedNotification = @"SearchDistanceChangedNotification";

static int DEFAULT_SEARCH_RANGE = 5;

@implementation Pref

- (id) init {
    self = [super init];
    if (self) {
        _authenticationToken = [NSStringPref prefWithKey:@"AUTHENTICATION_TOKEN"];
        _searchDistance = [NSNumberPref prefWithKey:@"SEARCH_NUMBER"
                                      defaultNumber:[NSNumber numberWithInt:DEFAULT_SEARCH_RANGE]];
    }
    return self;
}

@end