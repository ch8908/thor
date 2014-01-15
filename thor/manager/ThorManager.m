//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ThorManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "CoffeeShop.h"


NSString* LoadShopFailedNotification = @"LoadShopFailedNotification";
NSString* LoadShopSuccessNotification = @"LoadShopSuccessNotification";

@implementation ThorManager

+ (id) sharedInstance
{
    static ThorManager* sharedMyInstance = nil;

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

- (void) fetchShopsWithCenter:(CLLocationCoordinate2D) coordinate2D
{
    NSString* urlString = [NSString stringWithFormat:@"http://geekcoffee.roachking.net:80/api/v1/shops/near?lat=%f&lng=%f&distance=%d&per_page=500&page=1",
                                                     coordinate2D.latitude,
                                                     coordinate2D.longitude,
                                                     10];

    NSMutableArray* coffeeShops = [[NSMutableArray alloc] init];

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:urlString parameters:nil
         success:^(AFHTTPRequestOperation* operation, id responseObject) {
             NSString* encodeJsonData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSArray* jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
             for (NSDictionary* item in jsonDic)
             {
                 CoffeeShop* shop = [CoffeeShop map:item];
                 [coffeeShops addObject:shop];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:LoadShopSuccessNotification object:coffeeShops];
         }
         failure:^(AFHTTPRequestOperation* operation, NSError* error) {
             NSLog(@">>>>> request failed");
             [[NSNotificationCenter defaultCenter] postNotificationName:LoadShopFailedNotification object:nil];
         }];
}

@end