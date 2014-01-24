//
// Created by Huang ChienShuo on 1/23/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddShopViewController.h"
#import "Views.h"
#import "I18N.h"

CGFloat PADDING_HORIZONTAL = 10;

@interface AddShopViewController()<MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
@property MKMapView* mapView;
@property (nonatomic) BOOL initUserLocation;
@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) CLGeocoder* geocoder;
@property (nonatomic) UIImageView* centerPin;
@property (nonatomic) UITextView* addressTextViewFromMap;
@property (nonatomic) UILabel* addressTitle;
@property (nonatomic) UILabel* inputAddressTitle;
@property (nonatomic) UITextField* inputAddressField;
@property (nonatomic) UIActivityIndicatorView* indicatorViewForMap;
@end

@implementation AddShopViewController

- (id) initAddShopViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;

        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        _geocoder = [[CLGeocoder alloc] init];
        _centerPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/icon_map_center_pin.png"]];

        _addressTextViewFromMap = [[UITextView alloc] init];
        self.addressTextViewFromMap.editable = NO;
        self.addressTextViewFromMap.backgroundColor = [UIColor clearColor];
        self.addressTextViewFromMap.textColor = [UIColor blackColor];
        self.addressTextViewFromMap.font = [UIFont systemFontOfSize:14];

        _addressTitle = [[UILabel alloc] init];
        self.addressTitle.backgroundColor = [UIColor clearColor];
        self.addressTitle.textColor = [UIColor grayColor];
        self.addressTitle.font = [UIFont systemFontOfSize:12];

        _inputAddressTitle = [[UILabel alloc] init];
        self.inputAddressTitle.backgroundColor = [UIColor clearColor];
        self.inputAddressTitle.textColor = [UIColor grayColor];
        self.inputAddressTitle.font = [UIFont systemFontOfSize:12];

        _inputAddressField = [[UITextField alloc] init];
        self.inputAddressField.font = [UIFont systemFontOfSize:12];
        self.inputAddressField.backgroundColor = [UIColor lightGrayColor];
        self.inputAddressField.textColor = [UIColor blackColor];
        self.inputAddressField.placeholder = [I18N key:@"input_address_placeholder"];
        self.inputAddressField.delegate = self;

        _indicatorViewForMap = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(onCancel)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.mapView containerSize:CGSizeMake(self.view.bounds.size.width, 150)];
    [Views locate:self.mapView y:self.topBarOffset];

    [Views alignCenterMiddle:self.centerPin containerFrame:self.mapView.bounds];

    self.addressTitle.text = [I18N key:@"address_above_title"];
    [self.addressTitle sizeToFit];
    [Views locate:self.addressTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.mapView] + 10];

    [Views resize:self.indicatorViewForMap containerSize:CGSizeMake(24, 24)];
    [Views alignCenter:self.indicatorViewForMap withTarget:self.addressTitle];
    [Views locate:self.indicatorViewForMap x:[Views rightOf:self.addressTitle] + 3];

    self.inputAddressTitle.text = [I18N key:@"input_address_title"];
    [self.inputAddressTitle sizeToFit];
    [Views locate:self.inputAddressTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.addressTitle] + 50];

    [Views resize:self.inputAddressField
    containerSize:CGSizeMake(self.view.bounds.size.width - PADDING_HORIZONTAL * 2, 44)];
    [Views locate:self.inputAddressField x:PADDING_HORIZONTAL y:[Views bottomOf:self.inputAddressTitle] + 5];

    [self.mapView addSubview:self.centerPin];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.addressTitle];
    [self.view addSubview:self.indicatorViewForMap];
    [self.view addSubview:self.inputAddressTitle];
    [self.view addSubview:self.addressTextViewFromMap];
    [self.view addSubview:self.inputAddressField];
}

- (void) onCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
}

- (void) mapView:(MKMapView*) mapView regionWillChangeAnimated:(BOOL) animated
{
    [self.indicatorViewForMap startAnimating];
}


- (void) mapView:(MKMapView*) mapView regionDidChangeAnimated:(BOOL) animated
{
    CLLocation* location = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude
                                                      longitude:self.mapView.centerCoordinate.longitude];

    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray* placemarks, NSError* error) {
                            [self.indicatorViewForMap stopAnimating];
                            if (error)
                            {
                                return;
                            }
                            CLPlacemark* placemark = [placemarks lastObject];
                            if (placemark)
                            {
                                [self setAddressWithPlacemark:placemark];
                            }
                        }];
}

- (void) setAddressWithPlacemark:(CLPlacemark*) placemark
{
    NSString* addressString = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    NSString* newAddress = [addressString stringByReplacingOccurrencesOfString:@"\n"
                                                                    withString:@" "];
    self.addressTextViewFromMap.text = newAddress;
    [self.addressTextViewFromMap sizeToFit];
    [Views resize:self.addressTextViewFromMap containerWidth:self.view.bounds.size.width - PADDING_HORIZONTAL * 2];
    [Views locate:self.addressTextViewFromMap x:self.addressTitle.frame.origin.x
                y:[Views bottomOf:self.addressTitle] + 5];
}

- (void) setLocationWithPlacemark:(CLPlacemark*) placemark
{
    MKCoordinateSpan currentSpan = self.mapView.region.span;
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    mapRegion.span.latitudeDelta = currentSpan.latitudeDelta < 0.01 ? currentSpan.latitudeDelta : 0.01;
    mapRegion.span.longitudeDelta = currentSpan.longitudeDelta < 0.01 ? currentSpan.longitudeDelta : 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
}

- (void) textFieldDidEndEditing:(UITextField*) textField
{
    [self.indicatorViewForMap startAnimating];
    NSString* queryAddressString = textField.text;
    [self.geocoder geocodeAddressString:queryAddressString
                      completionHandler:^(NSArray* placemarks, NSError* error) {
                          [self.indicatorViewForMap stopAnimating];
                          if (error)
                          {
                              return;
                          }
                          CLPlacemark* placemark = [placemarks lastObject];
                          if (placemark)
                          {
                              [self setLocationWithPlacemark:placemark];
                          }
                      }];
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [self.inputAddressField resignFirstResponder];
    return YES;
}

@end