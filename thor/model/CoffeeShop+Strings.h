//
// Created by Huang ChienShuo on 1/16/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoffeeShop.h"

@interface CoffeeShop(Strings)
- (NSString*) distanceStringWithCenter:(CLLocationCoordinate2D) centerCoordinate;

- (NSString*) infoString;
@end