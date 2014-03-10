//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface AutoCompleteResult : NSObject
@property (nonatomic, strong) NSArray *candidates;
@property (nonatomic, copy) NSString *searchText;

- (id) initWithCandidates:(NSArray *) candidates searchText:(NSString *) searchText;

@end

@class SubmitInfo;
@class BFTask;

extern NSString *RegisterSuccessNotification;
extern NSString *RegisterFailedNotification;

extern NSString *SignInSuccessNotification;
extern NSString *SignInFailedNotification;

extern NSString *AddShopSuccessNotification;
extern NSString *AddShopFailedNotification;

@interface CoffeeService : NSObject
+ (id) sharedInstance;

- (BFTask *) fetchShopsWithCenter:(CLLocationCoordinate2D) coordinate2D searchDistance:(NSNumber *) distance;

- (BFTask *) fetchDetailWithShopId:(NSNumber *) number;

- (void) resisterWithParams:(NSDictionary *) dictionary;

- (void) signInWithEmail:(NSString *) email password:(NSString *) password;

- (void) submitShopInfo:(SubmitInfo *) info;

- (BFTask *) decodeShops:(id) object;

- (BFTask *) autoCompleteResultWithSearchText:(NSString *) searchText;

- (BFTask *) searchShopWithSearchText:(NSString *) searchText;
@end