//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "TRAnnotation.h"


@implementation TRAnnotation

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate name:(NSString*) name info:(NSString*) info
{
    self = [super init];
    if (self)
    {
        self.coordinate = coordinate;
        self.name = name;
        self.info = info;
    }

    return self;
}

- (NSString*) title
{
    return self.name;
}

- (NSString*) subtitle
{
    return self.info;
}

@end