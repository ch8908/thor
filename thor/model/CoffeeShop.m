//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "CoffeeShop.h"


@implementation CoffeeShop

- (instancetype) initWithId:(NSNumber *) id
                       name:(NSString *) name
                   latitude:(double) latitude
                  longitude:(double) longitude
                   wifiFree:(BOOL) wifiFree
                powerOutlet:(BOOL) powerOutlet
{
    self = [super init];
    if (self)
    {
        self.id = id;
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.wifiFree = wifiFree;
        self.powerOutlet = powerOutlet;
    }

    return self;
}

+ (instancetype) map:(NSDictionary *) raw
{
    NSNumber *id = [NSNumber numberWithLong:[[raw objectForKey:@"id"] longValue]];
    NSString *name = [raw objectForKey:@"name"];
    double latitude = [[raw objectForKey:@"lat"] doubleValue];
    double longitude = [[raw objectForKey:@"lng"] doubleValue];
    BOOL wifiFree = [[raw objectForKey:@"is_wifi_free"] boolValue];
    BOOL powerOutlet = [[raw objectForKey:@"power_outlets"] boolValue];
    return [[self alloc] initWithId:id
                               name:name
                           latitude:latitude
                          longitude:longitude
                           wifiFree:wifiFree
                        powerOutlet:powerOutlet];
}

- (BOOL) isEqual:(id) other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToShop:other];
}

- (BOOL) isEqualToShop:(CoffeeShop *) shop
{
    if (self == shop)
        return YES;
    if (shop == nil)
        return NO;
    if (self.id != shop.id && ![self.id isEqualToNumber:shop.id])
        return NO;
    return YES;
}

- (NSUInteger) hash
{
    return [self.id hash];
}

@end