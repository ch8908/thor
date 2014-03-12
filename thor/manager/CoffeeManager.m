//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "CoffeeManager.h"
#import "TRFilterState.h"
#import "CoffeeShop.h"
#import "BFTaskCompletionSource.h"


@interface CoffeeManager()
@property (nonatomic, strong) dispatch_queue_t queue;
@end

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
        _queue = dispatch_queue_create("com.osolve.thor.manager", NULL);
    }
    return self;
}

- (BFTask *) allShops:(NSArray *) shops filterState:(TRFilterState *) filterState
{
    BFTaskCompletionSource *completer = [BFTaskCompletionSource taskCompletionSource];

    dispatch_async(self.queue, ^{
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
        [completer setResult:[filteredResult copy]];
    });

    return completer.task;
}

@end
