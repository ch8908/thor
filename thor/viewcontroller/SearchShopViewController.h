//
// Created by Huang ChienShuo on 3/9/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *SearchShopSuccessNotification;

@interface SearchShopViewController : UIViewController
- (id) initWithMainViewController:(UIViewController *) mainViewController;

- (void) searchBarBecomeFirstResponder;
@end