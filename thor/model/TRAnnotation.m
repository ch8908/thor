//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TRAnnotation.h"


@implementation TRAnnotation

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate
                                 id:(NSNumber *) id
                               name:(NSString *) name
                               info:(NSString *) info
{
    self = [super init];
    if (self)
    {
        self.coordinate = coordinate;
        self.id = id;
        self.name = name;
        self.info = info;
    }

    return self;
}

- (NSString *) title
{
    return self.name;
}

- (NSString *) subtitle
{
    return self.info;
}

- (BOOL) isEqual:(id) other
{
    if (!other || ![[other class] isEqual:[self class]])
    {
        return NO;
    }
    if (other == self)
    {
        return YES;
    }
    if ([self.id isEqualToNumber:((TRAnnotation *) other).id])
    {
        return YES;
    }
    return NO;
}

- (NSUInteger) hash
{
    return [super hash];
}

@end