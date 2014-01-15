//
// Created by Huang ChienShuo on 8/20/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "ViewParams.h"
#import "I18N.h"
#import "LoginViewController.h"
#import "ThorNavigationController.h"
#import "ThorManager.h"
#import "CoffeeShop.h"
#import "TRAnnotation.h"
#import "CoffeeShop+Strings.h"


@interface MainViewController()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) MKMapView* mapView;
@property (nonatomic) UITableView* tableView;
@property (nonatomic) NSMutableArray* coffeeShops;
@property (nonatomic) NSMutableDictionary* annotations;
@end

@implementation MainViewController

- (id) initWithMainView
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.navigationItem.title = [I18N key:@"places_title"];

        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.mapView];
        [self.view addSubview:self.tableView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadShopSuccessNotification:)
                                                     name:LoadShopSuccessNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadShopFailedNotification)
                                                     name:LoadShopFailedNotification object:nil];
    }

    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.coffeeShops = [[NSMutableArray alloc] init];
    UIBarButtonItem* loginButton = [[UIBarButtonItem alloc] initWithTitle:[I18N key:@"login"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(login)];
    [self.navigationItem setRightBarButtonItem:loginButton];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect mapViewFrame = CGRectMake(0, 0, [ViewParams screenWidth], 200);
    self.mapView.frame = mapViewFrame;

    CGRect tableViewFrame = CGRectMake(0,
                                       mapViewFrame.origin.y + mapViewFrame.size.height,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - mapViewFrame.size.height);
    self.tableView.frame = tableViewFrame;
}

- (void) onLoadShopFailedNotification
{

}

- (void) onLoadShopSuccessNotification:(NSNotification*) notification
{
    self.coffeeShops = notification.object;
    [self showOnMap];
    [self.tableView reloadData];
}

- (void) showOnMap
{
    if (self.annotations)
    {
        self.annotations = nil;
    }
    self.annotations = [[NSMutableDictionary alloc] init];
    for (CoffeeShop* coffeeShop in self.coffeeShops)
    {
        TRAnnotation* annotation = [[TRAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(coffeeShop.latitude, coffeeShop.longitude)
                                                                         id:coffeeShop.id
                                                                       name:coffeeShop.name
                                                                       info:coffeeShop.infoString];
        [self.mapView addAnnotation:annotation];
        [self.annotations setObject:annotation forKey:coffeeShop.id];
    }
}

- (void) login
{
    ThorNavigationController* navigationController = [[ThorNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initLogin]];
    [self.navigationController presentViewController:navigationController
                                            animated:YES completion:nil];
}

- (void) mapView:(MKMapView*) mapView didUpdateUserLocation:(MKUserLocation*) userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
    [[ThorManager sharedInstance] fetchShopsWithCenter:self.mapView.userLocation.coordinate];
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.coffeeShops.count;
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    static NSString* CellIdentifier = @"Cell";

    UITableViewCell* cell = (UITableViewCell*)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }

    CoffeeShop* coffeeShop = self.coffeeShops[(NSUInteger) indexPath.row];
    cell.textLabel.text = coffeeShop.name;
    cell.detailTextLabel.text = [coffeeShop distanceStringWithCenter:self.mapView.userLocation.coordinate];
    return cell;
}

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
    CoffeeShop* shop = self.coffeeShops[(NSUInteger) indexPath.row];
    [self setMapCenterToShop:shop];
    [self openAnnotationWithShop:shop];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) openAnnotationWithShop:(CoffeeShop*) coffeeShop
{
    TRAnnotation* shopAnnotation = [self.annotations objectForKey:coffeeShop.id];
    if (shopAnnotation)
    {
        [self.mapView selectAnnotation:shopAnnotation animated:YES];
    }
}

- (void) setMapCenterToShop:(CoffeeShop*) shop
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(shop.latitude, shop.longitude);
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
}

@end