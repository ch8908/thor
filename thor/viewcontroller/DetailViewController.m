//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "AbstractUIViewController.h"
#import "DetailViewController.h"
#import "CoffeeService.h"
#import "Views.h"
#import "UIColor+Constant.h"
#import "CoffeeShopDetail.h"

@interface DetailViewController()
@property (nonatomic) UIImageView* shopImageView;
@property (nonatomic) UILabel* addressLable;
@property (nonatomic) UIImageView* nameLabel;
@property (nonatomic) UILabel* urlLabel;
@property (nonatomic) NSNumber* id;
@property (nonatomic) CoffeeShopDetail* coffeeShopDetail;
@end

@implementation DetailViewController

- (id) initDetailViewControllerWithId:(NSNumber*) id
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        _id = id;
        [[CoffeeService sharedInstance] fetchDetailWithShopId:id];

        _shopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/image_placeholder.png"]];

        _addressLable = [[UILabel alloc] init];
        self.addressLable.textColor = [UIColor addressTextColor];
        self.addressLable.font = [UIFont systemFontOfSize:18];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadShopDetailSuccessNotification:)
                                                     name:LoadShopDetailSuccessNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadShopDetailFailedNotification)
                                                     name:LoadShopDetailFailedNotification object:nil];
    }

    return self;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.addressLable.text = self.coffeeShopDetail.address;
    [self.addressLable sizeToFit];

    [Views alignCenter:self.shopImageView containerWidth:self.view.bounds.size.width];
    [Views locate:self.shopImageView y:self.topBarOffset];

    [Views locate:self.addressLable y:[Views bottomOf:self.shopImageView]];

    [self.view addSubview:self.shopImageView];
    [self.view addSubview:self.addressLable];
}

- (void) onLoadShopDetailSuccessNotification:(NSNotification*) notification
{
    self.coffeeShopDetail = notification.object;
    [self.view setNeedsLayout];
}

- (void) onLoadShopDetailFailedNotification
{

}

@end