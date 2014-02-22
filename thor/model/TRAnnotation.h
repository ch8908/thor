//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface TRAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *info;

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate
                                 id:(NSNumber *) id
                               name:(NSString *) name
                               info:(NSString *) info;

@end