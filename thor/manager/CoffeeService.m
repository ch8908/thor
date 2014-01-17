//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CoffeeService.h"
#import "CoffeeShop.h"
#import "JSONKit.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "CoffeeShopDetail.h"

NSString* LoadShopFailedNotification = @"LoadShopFailedNotification";
NSString* LoadShopSuccessNotification = @"LoadShopSuccessNotification";

NSString* LoadShopDetailSuccessNotification = @"LoadShopDetailSuccessNotification";
NSString* LoadShopDetailFailedNotification = @"LoadShopDetailFailedNotification";

static NSString* BASE_API_URL = @"http://geekcoffee.roachking.net:80/api/v1";

@implementation CoffeeService

+ (id) sharedInstance
{
    static CoffeeService* sharedMyInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] initService];
    });

    return sharedMyInstance;
}

- (id) initService
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void) fetchShopsWithCenter:(CLLocationCoordinate2D) coordinate2D
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/shops/near"];

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithDouble:coordinate2D.latitude] forKey:@"lat"];
    [params setObject:[NSNumber numberWithDouble:coordinate2D.longitude] forKey:@"lng"];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"distance"];
    [params setObject:[NSNumber numberWithInt:500] forKey:@"per_page"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"page"];

    NSMutableArray* coffeeShops = [[NSMutableArray alloc] init];

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:urlString parameters:params
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

- (void) fetchDetailWithShopId:(NSNumber*) number
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@", BASE_API_URL, @"/shops/", number];

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:urlString parameters:nil
         success:^(AFHTTPRequestOperation* operation, id responseObject) {
             NSString* encodeJsonData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSDictionary* jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];

             CoffeeShopDetail* detail = [CoffeeShopDetail map:jsonDic];

             [[NSNotificationCenter defaultCenter] postNotificationName:LoadShopDetailSuccessNotification
                                                                 object:detail];
         }
         failure:^(AFHTTPRequestOperation* operation, NSError* error) {
             NSLog(@">>>>> request failed");
             [[NSNotificationCenter defaultCenter] postNotificationName:LoadShopDetailFailedNotification object:nil];
         }];
}

@end