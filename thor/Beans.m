//
// Created by Huang ChienShuo on 8/22/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Beans.h"
#import "FacebookDaemon.h"


@implementation Beans
@synthesize facebookDaemon = _facebookDaemon;

+ (id) sharedInstance
{
    static Beans* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (Beans*) [[super allocWithZone:nil] init];
    });

    return sharedInstance;
}

+ (id) allocWithZone:(NSZone*) zone
{
    return [self sharedInstance];
}

- (void) configure
{
    _facebookDaemon = [[FacebookDaemon alloc] init];
}


@end