//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRFilterState;
@class BFTask;

@interface CoffeeManager : NSObject
- (id) initManager;

- (BFTask *) allShops:(NSArray *) array filterState:(TRFilterState *) filterState;
@end