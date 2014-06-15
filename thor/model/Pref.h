//
// Created by liq on 12/24/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractPref.h"

extern NSString *const SearchDistanceChangedNotification;

@interface Pref : AbstractPref
@property (nonatomic, readonly, strong) NSStringPref *authenticationToken;
@property (nonatomic, readonly, strong) NSNumberPref *searchDistance;
@end