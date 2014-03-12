//
// Created by Huang ChienShuo on 2/23/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#include "TRFilterState.h"

@implementation TRFilterState
- (id) init
{
    self = [super init];
    if (self)
    {
        _needWifi = NO;
        _needPower = NO;
    }

    return self;
}
@end