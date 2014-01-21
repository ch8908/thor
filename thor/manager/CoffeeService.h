//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

extern NSString* LoadShopFailedNotification;
extern NSString* LoadShopSuccessNotification;
extern NSString* LoadShopDetailSuccessNotification;
extern NSString* LoadShopDetailFailedNotification;
extern NSString* RegisterFailedNotification;
extern NSString* SignInSuccessNotification;
extern NSString* SignInFailedNotification;

@interface CoffeeService : NSObject
+ (id) sharedInstance;

- (void) fetchShopsWithCenter:(CLLocationCoordinate2D) coordinate2D;

- (void) fetchDetailWithShopId:(NSNumber*) number;

- (void) resisterWithParams:(NSDictionary*) dictionary;

- (void) signInWithEmail:(NSString*) email password:(NSString*) password;
@end