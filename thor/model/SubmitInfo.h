//
// Created by Huang ChienShuo on 1/25/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SubmitInfo : NSObject
@property NSString *name;
@property NSString *phone;
@property NSString *website_rul;
@property BOOL is_wifi_free;
@property BOOL power_outlets;
@property NSString *hours;
@property NSString *shopDescription;
@property double latitude;
@property double longitude;
@property NSString *address;

- (instancetype) initWithName:(NSString *) name phone:(NSString *) phone website_rul:(NSString *) website_rul is_wifi_free:(BOOL) is_wifi_free power_outlets:(BOOL) power_outlets hours:(NSString *) hours shopDescription:(NSString *) shopDescription latitude:(double) latitude longitudeDelta:(double) longitudeDelta address:(NSString *) address;

+ (instancetype) infoWithName:(NSString *) name phone:(NSString *) phone website_rul:(NSString *) website_rul is_wifi_free:(BOOL) is_wifi_free power_outlets:(BOOL) power_outlets hours:(NSString *) hours shopDescription:(NSString *) shopDescription latitude:(double) latitude longitudeDelta:(double) longitudeDelta address:(NSString *) address;

- (NSDictionary *) infoAsDictionaryWithToken:(NSString *) token;
@end