//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoffeeService;


@interface AbstractState : NSObject

@property (nonatomic) CoffeeService *service;

- (void) enter;

- (void) execute;

- (void) exit;

@end