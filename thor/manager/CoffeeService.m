//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Bolts/BFTask.h>
#import <Bolts/BFTaskCompletionSource.h>
#import "CoffeeService.h"
#import "CoffeeShop.h"
#import "JSONKit.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "CoffeeShopDetail.h"
#import "SubmitInfo.h"
#import "LogStateMachine.h"

NSString *SignInSuccessNotification = @"SignInSuccessNotification";
NSString *SignInFailedNotification = @"SignInFailedNotification";

NSString *RegisterSuccessNotification = @"RegisterSuccessNotification";
NSString *RegisterFailedNotification = @"RegisterFailedNotification";

NSString *AddShopSuccessNotification = @"AddShopSuccessNotification";
NSString *AddShopFailedNotification = @"AddShopFailedNotification";

static NSString *BASE_API_URL = @"http://geekcoffee-staging.roachking.net/api/v1";

@interface CoffeeService()
@property (nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation CoffeeService

+ (id) sharedInstance
{
    static CoffeeService *sharedMyInstance = nil;

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
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

- (BFTask *) afNetworkingGet:(NSString *) urlString parameters:(NSDictionary *) params
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:urlString parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [completionSource setResult:responseObject];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [completionSource setError:error];
         }];

    return completionSource.task;
}

- (BFTask *) fetchShopsWithCenter:(CLLocationCoordinate2D) coordinate2D searchDistance:(NSNumber *) distance
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/shops/near"];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithDouble:coordinate2D.latitude] forKey:@"lat"];
    [params setObject:[NSNumber numberWithDouble:coordinate2D.longitude] forKey:@"lng"];
    [params setObject:distance forKey:@"distance"];
    [params setObject:[NSNumber numberWithInt:500] forKey:@"per_page"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"page"];

    __weak CoffeeService *preventCircularRef = self;
    return [[self afNetworkingGet:urlString parameters:params] continueWithSuccessBlock:^id(BFTask *task) {
        return [preventCircularRef decodeShops:task.result];
    }];
}

- (BFTask *) decodeShops:(id) responseObject
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *coffeeShops = [[NSMutableArray alloc] init];

        NSString *encodeJsonData = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        NSArray *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        for (NSDictionary *item in jsonDic)
        {
            CoffeeShop *shop = [CoffeeShop map:item];
            [coffeeShops addObject:shop];
        }
        [completionSource setResult:[coffeeShops copy]];
    });
    return completionSource.task;
}

- (BFTask *) fetchDetailWithShopId:(NSNumber *) number
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_API_URL, @"/shops/", number];

    __weak CoffeeService *preventCircularRef = self;

    return [[self afNetworkingGet:urlString parameters:nil] continueWithSuccessBlock:^id(BFTask *task) {
        return [preventCircularRef decodeDetail:task.result];
    }];
}

- (BFTask *) decodeDetail:(id) responseObject
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *encodeJsonData = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];

        CoffeeShopDetail *detail = [CoffeeShopDetail map:jsonDic];
        [completionSource setResult:detail];
    });
    return completionSource.task;
}

- (void) resisterWithParams:(NSDictionary *) dictionary
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/users/sign_up"];

    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [self.manager POST:urlString parameters:dictionary
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSString *encodeJsonData = [[NSString alloc] initWithData:responseObject
                                                                    encoding:NSUTF8StringEncoding];
                   NSLog(@">>>>>> encodeJsonData:%@", encodeJsonData);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSString *encodeJsonData = [[NSString alloc] initWithData:operation.responseObject
                                                                    encoding:NSUTF8StringEncoding];
                   NSDictionary *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];

                   [[NSNotificationCenter defaultCenter] postNotificationName:RegisterFailedNotification
                                                                       object:[jsonDic objectForKey:@"error"]];
                   NSLog(@">>>> resisterWithParams failed json:%@", encodeJsonData);
               }];
}


- (void) signInWithEmail:(NSString *) email password:(NSString *) password
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/users/tokens/create"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];

    [self.manager POST:urlString parameters:params
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSString *encodeJsonData = [[NSString alloc] initWithData:operation.responseObject
                                                                    encoding:NSUTF8StringEncoding];
                   NSDictionary *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];

                   [[NSNotificationCenter defaultCenter] postNotificationName:SignInSuccessNotification
                                                                       object:[jsonDic objectForKey:@"authentication_token"]];
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSString *encodeJsonData = [[NSString alloc] initWithData:operation.responseObject
                                                                    encoding:NSUTF8StringEncoding];
                   NSDictionary *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
                   [[NSNotificationCenter defaultCenter] postNotificationName:SignInFailedNotification
                                                                       object:[jsonDic objectForKey:@"error"]];
               }];
}

- (void) submitShopInfo:(SubmitInfo *) info
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/shops"];

    NSDictionary *parameters = [info infoAsDictionaryWithToken:[[LogStateMachine sharedInstance] authToken]];

    [self.manager POST:urlString
            parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSString *encodeJsonData = [[NSString alloc] initWithData:operation.responseObject
                                                                    encoding:NSUTF8StringEncoding];
                   NSDictionary *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];

                   [[NSNotificationCenter defaultCenter] postNotificationName:AddShopSuccessNotification
                                                                       object:[jsonDic objectForKey:@"authentication_token"]];
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSString *encodeJsonData = [[NSString alloc] initWithData:operation.responseObject
                                                                    encoding:NSUTF8StringEncoding];
                   NSDictionary *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
                   [[NSNotificationCenter defaultCenter] postNotificationName:AddShopFailedNotification
                                                                       object:[jsonDic objectForKey:@"error"]];
               }];
}

@end