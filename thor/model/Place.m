//
// Created by Huang ChienShuo on 8/21/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Place.h"


@interface Place()

@end

@implementation Place
@synthesize name = _name;
@synthesize id = _id;
@synthesize address = _address;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


- (id) initWithName:(NSString*) name
                 id:(NSString*) id
            address:(NSString*) address
           latitude:(double) latitude
          longitude:(double) longitude
{
    self = [super init];
    if (self)
    {
        _name = name;
        _id = id;
        _address = address;
        _latitude = latitude;
        _longitude = longitude;
    }

    return self;
}

@end