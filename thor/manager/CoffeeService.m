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
#import "NSArray+Util.h"

@implementation AutoCompleteResult

- (id) initWithCandidates:(NSArray *) candidates searchText:(NSString *) searchText
{
    self = [super init];
    if (self)
    {
        _candidates = candidates;
        _searchText = searchText;
    }

    return self;
}

- (NSString *) description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.candidates=%@", self.candidates];
    [description appendFormat:@", self.searchText=%@", self.searchText];
    [description appendString:@">"];
    return description;
}

@end

NSString *const THCoffeeServiceErrorDomain = @"com.osolve.thor";

NSString *RegisterSuccessNotification = @"RegisterSuccessNotification";
NSString *RegisterFailedNotification = @"RegisterFailedNotification";

NSString *AddShopSuccessNotification = @"AddShopSuccessNotification";
NSString *AddShopFailedNotification = @"AddShopFailedNotification";

NSString const *BASE_API_URL = @"http://geekcoffee-staging.roachking.net/api/v1";

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

#pragma Encapsulate method

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

- (BFTask *) afNetworkingPOST:(NSString *) urlString parameters:(NSDictionary *) params
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [completionSource setResult:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //TODO - handle network issue
              NSString *encodeJsonData = [[NSString alloc] initWithData:operation.responseObject
                                                               encoding:NSUTF8StringEncoding];
              NSDictionary *jsonDic = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
              NSString *errorMessage = [jsonDic objectForKey:@"error"];


              NSError *serviceError = [[NSError alloc] initWithDomain:THCoffeeServiceErrorDomain
                                                                 code:TRCoffeeServiceServerReturnErrorCode
                                                             userInfo:@{NSLocalizedDescriptionKey : errorMessage}];

              [completionSource setError:serviceError];
          }];

    return completionSource.task;
}

#pragma Get shops around you

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

#pragma Get shop details

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

#pragma Register method

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

#pragma Sign In method

- (BFTask *) signInWithEmail:(NSString *) email password:(NSString *) password
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/users/tokens/create"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];

    return [[self afNetworkingPOST:urlString parameters:params]
                  continueWithSuccessBlock:^id(BFTask *task) {

                      NSString *encodedJsonData = [[NSString alloc] initWithData:task.result
                                                                        encoding:NSUTF8StringEncoding];

                      NSDictionary *jsonDic = [encodedJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];

                      NSString *token = [jsonDic objectForKey:@"authentication_token"];

                      return [BFTask taskWithResult:token];
                  }];
}

#pragma Add new coffee shop method

- (BFTask *) submitShopInfo:(SubmitInfo *) info
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/shops"];

    NSDictionary *parameters = [info infoAsDictionaryWithToken:[[LogStateMachine sharedInstance] authToken]];

    return [[self afNetworkingPOST:urlString parameters:parameters]
                  continueWithSuccessBlock:^id(BFTask *task) {
                      return [BFTask taskWithResult:nil];
                  }];
}

#pragma Search meghod

- (BFTask */*@[AutoCompleteResult]*/) autoCompleteResultWithSearchText:(NSString *) searchText
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_API_URL, @"/shops/search"];
    NSDictionary *params = @{@"query" : [searchText copy]};
    return [[self afNetworkingGet:urlString parameters:params] continueWithSuccessBlock:^id(BFTask *task) {
        return [self decodeSearchResult:task.result searchText:searchText];
    }];
}

- (BFTask *) decodeSearchResult:(id) responseObject searchText:(NSString *) searchText
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *encodeJsonData = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [encodeJsonData objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSArray *candidates = [jsonArray map:^id(NSDictionary *raw, NSUInteger index) {
            return [CoffeeShop map:raw];
        }];

        [completionSource setResult:[[AutoCompleteResult alloc] initWithCandidates:candidates
                                                                        searchText:searchText]];
    });
    return completionSource.task;
}

@end