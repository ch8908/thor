//
// Created by liq on 12/24/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractPref.h"

@interface Pref : AbstractPref
@property NSStringPref* authenticationToken;
@property NSNumberPref* searchDistance;

+ (id) sharedInstance;

@end