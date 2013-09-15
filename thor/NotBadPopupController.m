//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NotBadPopupController.h"
#import "I18N.h"


@implementation NotBadPopupController

- (id) initNotBadPopup
{
    self = [super initWithPopup];
    if (self)
    {
        self.titleLabel.text = [I18N key:@"not_bad_popup_title"];
    }

    return self;
}

@end