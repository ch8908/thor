//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "AbstractUIViewController.h"
#import "DetailViewController.h"
#import "CoffeeService.h"
#import "Views.h"
#import "CoffeeShopDetail.h"
#import "I18N.h"
#import "CoffeeShop.h"
#import "CoffeeShop+Strings.h"
#import "NSString+Util.h"


enum
{
    ShopName = 0,
    ShopAddress,
    ShopDescription,
    ShopHour,
    ShopWebSite,
    ShopWifiPower,
    DetailTotalCount
};

@interface DetailViewController()<UITableViewDataSource, UITableViewDelegate>
@property UIImageView* shopImageView;
@property NSNumber* id;
@property CoffeeShopDetail* coffeeShopDetail;
@property UITableView* tableView;
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
        self.shopImageView.clipsToBounds = YES;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.shopImageView.bounds.size.height)
                                                  style:UITableViewStyleGrouped];

        self.tableView.dataSource = self;
        self.tableView.delegate = self;

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

    [Views alignCenter:self.shopImageView containerWidth:self.view.bounds.size.width];
    [Views locate:self.shopImageView y:self.topBarOffset];

    [Views locate:self.tableView y:[Views bottomOf:self.shopImageView]];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    [self.view addSubview:self.shopImageView];
    [self.view addSubview:self.tableView];
}

- (void) onLoadShopDetailSuccessNotification:(NSNotification*) notification
{
    self.coffeeShopDetail = notification.object;
    [self.tableView reloadData];
}

- (void) onLoadShopDetailFailedNotification
{

}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return DetailTotalCount;
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    static NSString* CellIdentifier = @"DetailCell";

    UITableViewCell* cell = (UITableViewCell*)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row)
    {
        case ShopName:
            cell.textLabel.text = [I18N key:@"shop_name_title"];
            cell.detailTextLabel.text = self.coffeeShopDetail.coffeeShop.name;
            break;
        case ShopAddress:
            cell.textLabel.text = [I18N key:@"address_title"];
            cell.detailTextLabel.text = self.coffeeShopDetail.address;
            break;
        case ShopDescription:
        {
            cell.textLabel.text = [I18N key:@"desctiption_title"];
            if (![NSString isEmptyAfterTrim:self.coffeeShopDetail.shopDescription])
            {
                cell.detailTextLabel.text = self.coffeeShopDetail.shopDescription;
            }
            break;
        }
        case ShopHour:
        {
            cell.textLabel.text = [I18N key:@"hour_title"];
            if (![NSString isEmptyAfterTrim:self.coffeeShopDetail.hours])
            {
                cell.detailTextLabel.text = self.coffeeShopDetail.hours;
            }
            break;
        }
        case ShopWebSite:
        {
            cell.textLabel.text = [I18N key:@"website_title"];
            if (![NSString isEmptyAfterTrim:self.coffeeShopDetail.websiteUrl])
            {
                cell.detailTextLabel.text = self.coffeeShopDetail.websiteUrl;
            }
            break;
        }
        case ShopWifiPower:
            cell.textLabel.text = [I18N key:@"wifi_power_title"];
            cell.detailTextLabel.text = self.coffeeShopDetail.coffeeShop.infoString;
            break;
        default:
            return nil;
    }

    return cell;
}

@end