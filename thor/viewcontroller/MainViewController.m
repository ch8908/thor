//
// Created by Huang ChienShuo on 8/20/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "I18N.h"
#import "LoginViewController.h"
#import "ThorNavigationController.h"
#import "CoffeeShop.h"
#import "TRAnnotation.h"
#import "CoffeeShop+Strings.h"
#import "Views.h"
#import "CoffeeService.h"
#import "DetailViewController.h"
#import "LogStateMachine.h"


@interface MainViewController()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) MKMapView* mapView;
@property (nonatomic) UITableView* tableView;
@property (nonatomic) NSMutableArray* coffeeShops;
@property (nonatomic) NSMutableDictionary* annotations;
@property (nonatomic) UIButton* locateButton;
@property (nonatomic) BOOL initUserLocation;
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

        _locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locateButton setImage:[UIImage imageNamed:@"image/button_locate_normal.png"]
                           forState:UIControlStateNormal];
        [self.locateButton setImage:[UIImage imageNamed:@"image/button_locate_pressed.png"]
                           forState:UIControlStateHighlighted];
        [self.locateButton sizeToFit];
        [self.locateButton addTarget:self action:@selector(setMapCenterUser)
                    forControlEvents:UIControlEventTouchUpInside];

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
    NSString* loginString = [[LogStateMachine sharedInstance] isLogin] ? [I18N key:@"login"] : [I18N key:@"log_in"];
    UIBarButtonItem* loginButton = [[UIBarButtonItem alloc] initWithTitle:loginString
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(login)];
    [self.navigationItem setRightBarButtonItem:loginButton];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.mapView containerSize:CGSizeMake(self.view.bounds.size.width, 260)];
    [Views resize:self.tableView
    containerSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - self.mapView.bounds.size.height)];

    [Views locate:self.tableView y:[Views bottomOf:self.mapView]];
    [Views alignBottom:self.locateButton withTarget:self.mapView];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.locateButton];
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
    if (self.initUserLocation)
    {
        return;
    }
    MKCoordinateRegion mapRegion;
    mapRegion.center = userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
    self.initUserLocation = YES;
    [[CoffeeService sharedInstance] fetchShopsWithCenter:userLocation.coordinate];
}

- (MKAnnotationView*) mapView:(MKMapView*) mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
    MKPinAnnotationView* mapPin = nil;
    if (annotation != self.mapView.userLocation)
    {
        static NSString* defaultPinID = @"defaultPin";
        mapPin = (MKPinAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (mapPin == nil )
        {
            mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:defaultPinID];
            mapPin.canShowCallout = YES;
            UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            mapPin.rightCalloutAccessoryView = infoButton;
        }
        else
            mapPin.annotation = annotation;

    }
    return mapPin;
}

- (void) mapView:(MKMapView*) mapView annotationView:(MKAnnotationView*) view calloutAccessoryControlTapped:(UIControl*) control
{
    if (![view.annotation isKindOfClass:[TRAnnotation class]])
    {
        return;
    }
    TRAnnotation* annotation = (TRAnnotation*) view.annotation;
    DetailViewController* controller = [[DetailViewController alloc] initDetailViewControllerWithId:annotation.id];
    [self.navigationController pushViewController:controller animated:YES];

}

- (void) mapView:(MKMapView*) mapView didSelectAnnotationView:(MKAnnotationView*) view
{
    [self setMapCenterToCoordinate:view.annotation.coordinate];
    [self selectCellWithAnnotation:(TRAnnotation*) view.annotation];
}

- (void) selectCellWithAnnotation:(TRAnnotation*) annotation
{
    NSNumber* id = annotation.id;
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
    CoffeeShop* selectedShop = self.coffeeShops[(NSUInteger) selectedIndexPath.row];

    if ([selectedShop.id isEqualToNumber:id])
    {
        return;
    }

    NSInteger index = -1;
    for (NSUInteger i = 0; i < self.coffeeShops.count; i++)
    {
        CoffeeShop* shop = self.coffeeShops[i];
        if ([shop.id isEqualToNumber:id])
        {
            index = i;
            break;
        }
    }

    if (index < 0)
    {
        return;
    }

    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                            inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
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
    [self openAnnotationWithShop:shop];
}

- (void) openAnnotationWithShop:(CoffeeShop*) coffeeShop
{
    TRAnnotation* shopAnnotation = [self.annotations objectForKey:coffeeShop.id];
    if (shopAnnotation)
    {
        [self.mapView selectAnnotation:shopAnnotation animated:YES];
    }
}

- (void) setMapCenterUser
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
}

- (void) setMapCenterToCoordinate:(CLLocationCoordinate2D) coordinate
{
    MKCoordinateSpan currentSpan = self.mapView.region.span;
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    mapRegion.span.latitudeDelta = currentSpan.latitudeDelta < 0.01 ? currentSpan.latitudeDelta : 0.01;
    mapRegion.span.longitudeDelta = currentSpan.longitudeDelta < 0.01 ? currentSpan.longitudeDelta : 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
}

@end