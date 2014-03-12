//
// Created by Huang ChienShuo on 2/22/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ExternalApp.h"


@implementation ExternalApp

+ (BOOL) supportGoogleMap
{
    NSURL *googleMapUrl = [NSURL URLWithString:@"comgooglemaps://"];
    return [[UIApplication sharedApplication] canOpenURL:googleMapUrl];
}

+ (void) openGoogleMapDirection:(CLLocationCoordinate2D) to
{
    //comgooglemaps://?saddr=,&daddr=,&directionsmode=walking
    /*
    saddr: Sets the starting point for directions searches. This can be a latitude,longitude or a query formatted address. If it is a query string that returns more than one result, the first result will be selected. If the value is left blank, then the user’s current location will be used.
    daddr: Sets the end point for directions searches. Has the same format and behavior as saddr.
    directionsmode: Method of transportation. Can be set to: driving, transit, bicycling or walking.
    * */
    NSString *url = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&directionsmode=walking",
                                               to.latitude, to.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void) openNativeNavigation:(CLLocationCoordinate2D) toLocation address:(NSString *) address
{
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:toLocation
                                                                                    addressDictionary:nil]];
    mapItem.name = address;
    NSDictionary *options = @{
      MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,
    };

    [mapItem openInMapsWithLaunchOptions:options];
}
@end