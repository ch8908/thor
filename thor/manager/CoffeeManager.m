//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "CoffeeManager.h"
#import "TRFilterState.h"
#import "CoffeeShop.h"


@implementation CoffeeManager

+ (id) sharedInstance
{
    static CoffeeManager *sharedMyInstance = nil;

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

- (NSArray *) allShops:(NSArray *) shops filterState:(TRFilterState *) filterState
{
    NSMutableArray *filteredResult = [NSMutableArray array];
    for (CoffeeShop *shop in shops)
    {
        BOOL wifiCheck = YES;
        BOOL powerCheck = YES;
        if (filterState.needWifi && !shop.wifiFree)
        {
            wifiCheck = NO;
        }

        if (filterState.needPower && !shop.powerOutlet)
        {
            powerCheck = NO;
        }
        if (wifiCheck && powerCheck)
        {
            [filteredResult addObject:shop];
        }
    }
    return [filteredResult copy];
}

@end
