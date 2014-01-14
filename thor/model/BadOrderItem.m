//
// Created by Huang ChienShuo on 9/5/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BadOrderItem.h"


@implementation BadOrderItem
@synthesize name = _name;
@synthesize comment = _comment;
@synthesize imageFileName = _imageFileName;
@synthesize poster = _poster;
@synthesize score = _score;
@synthesize orderId = _orderId;

- (id) initBadOrderItemWithName:(NSString*) name orderId:(NSString*) orderId comment:(NSString*) comment imageFileName:(NSString*) imageFileName poster:(NSString*) poster score:(NSInteger) score
{
    self = [super init];
    if (self)
    {
        _name = name;
        _orderId = orderId;
        _comment = comment;
        _imageFileName = imageFileName;
        _poster = poster;
        _score = score;
    }

    return self;
}


@end