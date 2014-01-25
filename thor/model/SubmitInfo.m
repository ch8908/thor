//
// Created by Huang ChienShuo on 1/25/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "SubmitInfo.h"


@implementation SubmitInfo

- (instancetype) initWithName:(NSString*) name
                        phone:(NSString*) phone
                  website_rul:(NSString*) website_rul
                 is_wifi_free:(BOOL) is_wifi_free
                power_outlets:(BOOL) power_outlets
                        hours:(NSString*) hours
              shopDescription:(NSString*) shopDescription
                     latitude:(double) latitude
               longitudeDelta:(double) longitudeDelta
                      address:(NSString*) address
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.phone = phone;
        self.website_rul = website_rul;
        self.is_wifi_free = is_wifi_free;
        self.power_outlets = power_outlets;
        self.hours = hours;
        self.shopDescription = shopDescription;
        self.latitude = latitude;
        self.longitude = longitudeDelta;
        self.address = address;
    }

    return self;
}

+ (instancetype) infoWithName:(NSString*) name
                        phone:(NSString*) phone
                  website_rul:(NSString*) website_rul
                 is_wifi_free:(BOOL) is_wifi_free
                power_outlets:(BOOL) power_outlets
                        hours:(NSString*) hours
              shopDescription:(NSString*) shopDescription
                     latitude:(double) latitude
               longitudeDelta:(double) longitudeDelta
                      address:(NSString*) address
{
    return [[self alloc] initWithName:name phone:phone website_rul:website_rul is_wifi_free:is_wifi_free
                        power_outlets:power_outlets hours:hours shopDescription:shopDescription latitude:latitude
                       longitudeDelta:longitudeDelta address:address];
}

- (NSDictionary*) infoAsDictionaryWithToken:(NSString*) token
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];

    [params setObject:self.name forKey:@"name"];
    [params setObject:self.phone forKey:@"phone"];
    [params setObject:self.website_rul forKey:@"website_url"];
    [params setObject:[NSNumber numberWithBool:self.is_wifi_free] forKey:@"is_wifi_free"];
    [params setObject:[NSNumber numberWithBool:self.power_outlets] forKey:@"power_outlets"];
    [params setObject:self.hours forKey:@"hours"];
    [params setObject:self.shopDescription forKey:@"description"];
    [params setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"lat"];
    [params setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"lng"];
    [params setObject:self.address forKey:@"address"];
    [params setObject:token forKey:@"authentication_token"];

    return [params copy];
}


@end