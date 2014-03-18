//
// Created by Huang ChienShuo on 1/25/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "SubmitInfo.h"


@implementation SubmitInfo

- (id) init
{
    self = [super init];
    if (self)
    {

    }

    return self;
}

- (instancetype) initWithName:(NSString *) name
                        phone:(NSString *) phone
                   websiteUrl:(NSString *) websiteUrl
                   isWifiFree:(BOOL) isWifiFree
                 powerOutlets:(BOOL) powerOutlets
                        hours:(NSString *) hours
              shopDescription:(NSString *) shopDescription
                     latitude:(double) latitude
               longitudeDelta:(double) longitudeDelta
                      address:(NSString *) address
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.phone = phone;
        self.websiteUrl = websiteUrl;
        self.isWifiFree = isWifiFree;
        self.powerOutlets = powerOutlets;
        self.hours = hours;
        self.shopDescription = shopDescription;
        self.latitude = latitude;
        self.longitude = longitudeDelta;
        self.address = address;
    }

    return self;
}

- (NSDictionary *) infoAsDictionaryWithToken:(NSString *) token
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:self.name forKey:@"name"];
    [params setObject:self.phone ? self.phone : @"" forKey:@"phone"];
    [params setObject:self.websiteUrl ? self.websiteUrl : @"" forKey:@"website_url"];
    [params setObject:[NSNumber numberWithBool:self.isWifiFree] forKey:@"is_wifi_free"];
    [params setObject:[NSNumber numberWithBool:self.powerOutlets] forKey:@"power_outlets"];
    [params setObject:self.hours ? self.hours : @"" forKey:@"hours"];
    [params setObject:self.shopDescription ? self.shopDescription : @"" forKey:@"description"];
    [params setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"lat"];
    [params setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"lng"];
    [params setObject:self.address forKey:@"address"];
    [params setObject:token forKey:@"authentication_token"];

    return [params copy];
}

- (NSString *) description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.name=%@", self.name];
    [description appendFormat:@", self.phone=%@", self.phone];
    [description appendFormat:@", self.website_rul=%@", self.websiteUrl];
    [description appendFormat:@", self.is_wifi_free=%d", self.isWifiFree];
    [description appendFormat:@", self.power_outlets=%d", self.powerOutlets];
    [description appendFormat:@", self.hours=%@", self.hours];
    [description appendFormat:@", self.shopDescription=%@", self.shopDescription];
    [description appendFormat:@", self.latitude=%f", self.latitude];
    [description appendFormat:@", self.longitude=%f", self.longitude];
    [description appendFormat:@", self.address=%@", self.address];
    [description appendString:@">"];
    return description;
}

@end