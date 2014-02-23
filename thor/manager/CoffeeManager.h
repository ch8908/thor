//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRFilterState;

@interface CoffeeManager : NSObject
+ (id) sharedInstance;

- (NSArray *) filterShops:(NSArray *) array filterState:(TRFilterState *) filterState;
@end