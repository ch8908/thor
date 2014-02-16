//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class SubmitInfo;

extern NSString* LoadShopFailedNotification;
extern NSString* LoadShopSuccessNotification;

extern NSString* LoadShopDetailSuccessNotification;
extern NSString* LoadShopDetailFailedNotification;

extern NSString* RegisterSuccessNotification;
extern NSString* RegisterFailedNotification;

extern NSString* SignInSuccessNotification;
extern NSString* SignInFailedNotification;

extern NSString* AddShopSuccessNotification;
extern NSString* AddShopFailedNotification;

@interface CoffeeService : NSObject
+ (id) sharedInstance;

- (void) fetchShopsWithCenter:(CLLocationCoordinate2D) coordinate2D searchDistance:(NSNumber*) distance;

- (void) fetchDetailWithShopId:(NSNumber*) number;

- (void) resisterWithParams:(NSDictionary*) dictionary;

- (void) signInWithEmail:(NSString*) email password:(NSString*) password;

- (void) submitShopInfo:(SubmitInfo*) info;
@end