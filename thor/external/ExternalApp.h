//
// Created by Huang ChienShuo on 2/22/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExternalApp : NSObject
+ (BOOL) supportGoogleMap;

+ (void) openGoogleMapDirection:(CLLocationCoordinate2D) to;

+ (void) openNativeNavigation:(CLLocationCoordinate2D) coordinate2D address:(NSString *) address;
@end