//
// Created by Huang ChienShuo on 8/22/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UserComment.h"


@implementation UserComment
@synthesize name = _name;
@synthesize comment = _comment;
@synthesize score = _score;

- (id) initUserCommentWithName:(NSString*) name comment:(NSString*) comment score:(NSInteger) score
{
    self = [super init];
    if (self)
    {
        _name = name;
        _comment = comment;
        _score = score;
    }

    return self;
}

@end