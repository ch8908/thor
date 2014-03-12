//
// Created by Huang ChienShuo on 1/16/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "CoffeeShop+Strings.h"
#import "I18N.h"


@implementation CoffeeShop(Strings)
- (NSString *) infoString
{
    return [NSString stringWithFormat:@"Wifi:%@, Power:%@", [self wifiFreeString], [self powerOutletString]];
}

- (NSString *) distanceStringWithCenter:(CLLocationCoordinate2D) centerCoordinate
{
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude
                                                            longitude:centerCoordinate.longitude];
    CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:self.latitude
                                                          longitude:self.longitude];
    CLLocationDistance meters = [centerLocation distanceFromLocation:shopLocation];

    return [self stringWithDistance:meters];
}

- (NSString *) stringWithDistance:(CLLocationDistance) meters
{
    if (meters < 1)
    {
        return [I18N key:@"distance_less_than_1_meter"];
    }
    else if (meters < 1000)
    {
        return [I18N key:@"distance_subtitle_meters",
                         [NSString stringWithFormat:@"%d", (int) meters]];
    }
    else
    {
        return [I18N key:@"distance_subtitle_km",
                         [NSString stringWithFormat:@"%d", (int) (meters / 1000)]];
    }
}

- (NSString *) powerOutletString
{
    return self.powerOutlet ? @"◯" : @"X";
}

- (NSString *) wifiFreeString
{
    return self.wifiFree ? @"◯" : @"X";
}

@end