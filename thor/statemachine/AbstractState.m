//
// Created by Huang ChienShuo on 1/19/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "AbstractState.h"


@implementation AbstractState

- (void) enter
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void) execute
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void) exit
{
    [self doesNotRecognizeSelector:_cmd];
}

@end