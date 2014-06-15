//
// Created by Huang ChienShuo on 6/15/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "Beans.h"
#import "CoffeeService.h"
#import "CoffeeManager.h"
#import "Pref.h"


@implementation Beans

+ (id) sharedInstance {
    static Beans *sharedMyInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] initBeans];
    });

    return sharedMyInstance;
}

- (id) initBeans {
    self = [super init];
    if (self) {
        _pref = [[Pref alloc] init];
        _coffeeManager = [[CoffeeManager alloc] initManager];
        _coffeeService = [[CoffeeService alloc] initWithPref:_pref];

    }
    return self;
}

@end