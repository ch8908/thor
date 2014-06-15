//
// Created by Huang ChienShuo on 6/15/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoffeeService;
@class CoffeeManager;
@class Pref;


@interface Beans : NSObject
@property (nonatomic, readonly, strong) CoffeeService *coffeeService;
@property (nonatomic, readonly, strong) CoffeeManager *coffeeManager;
@property (nonatomic, readonly, strong) Pref *pref;

+ (id) sharedInstance;

@end