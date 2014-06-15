//
// Created by Huang ChienShuo on 6/15/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "UIViewController+Beans.h"
#import "Beans.h"


@implementation UIViewController(Beans)
- (Beans *) beans {
    return [Beans sharedInstance];
}
@end