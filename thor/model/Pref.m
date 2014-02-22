//
// Created by liq on 12/24/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import "Pref.h"

static int DEFAULT_SEARCH_RANGE = 5;

@implementation Pref

+ (id) sharedInstance
{
    static Pref* sharedMyInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });

    return sharedMyInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _authenticationToken = [NSStringPref prefWithKey:@"AUTHENTICATION_TOKEN"];
        _searchDistance = [NSNumberPref prefWithKey:@"SEARCH_NUMBER"
                                      defaultNumber:[NSNumber numberWithInt:DEFAULT_SEARCH_RANGE]];
    }

    return self;
}

@end