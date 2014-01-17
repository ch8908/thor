//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "CoffeeManager.h"


@implementation CoffeeManager

+ (id) sharedInstance
{
    static CoffeeManager* sharedMyInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] initThorManager];
    });

    return sharedMyInstance;
}

- (id) initThorManager
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

@end