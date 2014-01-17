//
// Created by Huang ChienShuo on 1/18/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoffeeShop;


@interface CoffeeShopDetail : NSObject
@property (nonatomic) CoffeeShop* coffeeShop;
@property (nonatomic) NSString* address;
@property (nonatomic) NSString* shopDescription;
@property (nonatomic) NSString* hours;
@property (nonatomic) NSString* websiteUrl;
@property (nonatomic) NSNumber* avgRating;

- (instancetype) initWithCoffeeShop:(CoffeeShop*) coffeeShop address:(NSString*) address shopDescription:(NSString*) shopDescription hours:(NSString*) hours websiteUrl:(NSString*) websiteUrl avgRating:(NSNumber*) avgRating;

+ (instancetype) map:(NSDictionary*) raw;
@end