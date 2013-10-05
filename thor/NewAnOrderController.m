//
// Created by Huang ChienShuo on 10/5/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NewAnOrderController.h"
#import "Views.h"
#import "I18N.h"
#import "Place.h"


@interface NewAnOrderController()<UIActionSheetDelegate>
@property (nonatomic) UITextField* textField;
@property (nonatomic, strong) Place* place;
@end

@implementation NewAnOrderController
@synthesize textField = _textField;
@synthesize place = _place;

- (id) initWithPlaceId:(Place*) place;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        _place = place;
        self.navigationItem.title = place.name;

        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(onCancel)];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
    }

    return self;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIButton* addPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addPhotoButton addTarget:self action:@selector(addPhoto)
             forControlEvents:UIControlEventTouchUpInside];
    [addPhotoButton setTitle:[I18N key:@"add_photo_button_title"] forState:UIControlStateNormal];
    [addPhotoButton sizeToFit];
    [Views alignCenter:addPhotoButton containerWidth:self.view.bounds.size.width];
    [Views locate:addPhotoButton y:50];

    [self.view addSubview:addPhotoButton];
}

- (void) addPhoto
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:[I18N key:@"cancel"]
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

    [actionSheet addButtonWithTitle:[I18N key:@"take_a_photo"]];
    [actionSheet addButtonWithTitle:[I18N key:@"select_from_album"]];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet*) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{

}

- (void) onCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end