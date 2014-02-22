//
// Created by Huang ChienShuo on 1/18/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "CoffeeShopDetail.h"
#import "CoffeeShop.h"


@implementation CoffeeShopDetail

- (instancetype) initWithCoffeeShop:(CoffeeShop *) coffeeShop address:(NSString *) address shopDescription:(NSString *) shopDescription hours:(NSString *) hours websiteUrl:(NSString *) websiteUrl avgRating:(NSNumber *) avgRating
{
    self = [super init];
    if (self)
    {
        self.coffeeShop = coffeeShop;
        self.address = address;
        self.shopDescription = shopDescription;
        self.hours = hours;
        self.websiteUrl = websiteUrl;
        self.avgRating = avgRating;
    }

    return self;
}

+ (instancetype) map:(NSDictionary *) raw
{
    CoffeeShop *coffeeShop = [CoffeeShop map:raw];
    NSString *address = [raw objectForKey:@"address"];
    NSString *shopDescription = [raw objectForKey:@"description"];
    NSString *hours = [raw objectForKey:@"hours"];
    NSString *websiteUrl = [raw objectForKey:@"website_url"];
    float avgRating = [[raw objectForKey:@"avg_rating"] floatValue];

    return [[self alloc] initWithCoffeeShop:coffeeShop address:address
                            shopDescription:shopDescription hours:hours
                                 websiteUrl:websiteUrl avgRating:[NSNumber numberWithFloat:avgRating]];
}

@end