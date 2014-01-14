//
// Created by Huang ChienShuo on 8/30/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OrderDetailController.h"
#import "ViewParams.h"
#import "Views.h"
#import "BadOrderItem.h"
#import "UserComment.h"
#import "I18N.h"
#import "PopupViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "StillBadPopupController.h"
#import "NotBadPopupController.h"

static NSInteger BAD_BUTTON_TAG = 0;
static NSInteger NOT_BAD_BUTTON_TAG = 1;

@interface OrderDetailController()<UITableViewDataSource, UITableViewDelegate, PopupSubmitDelegate>
@property (nonatomic, readonly) UITableView* commentListTableView;
@property (nonatomic, readwrite) UIImageView* foodImageView;
@property (nonatomic, readonly) UILabel* originalCommentLabel;
@property (nonatomic, readonly) UILabel* scordLabel;
@property (nonatomic) BadOrderItem* badOrderItem;
@property (nonatomic, strong) NSMutableArray* otherComments;
@end

@implementation OrderDetailController
@synthesize commentListTableView = _commentListTableView;
@synthesize originalCommentLabel = _originalCommentLabel;
@synthesize foodImageView = _foodImageView;
@synthesize scordLabel = _scordLabel;
@synthesize badOrderItem = _badOrderItem;
@synthesize otherComments = _otherComments;


- (id) initWithOrderDetailWithItem:(BadOrderItem*) item
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.navigationItem.title = item.name;

        _badOrderItem = item;
        _originalCommentLabel = [[UILabel alloc] init];
        _scordLabel = [[UILabel alloc] init];
        _commentListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commentListTableView.dataSource = self;
        _commentListTableView.delegate = self;
        _foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [ViewParams screenWidth], 220)];

        UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(onTapImage)];

        [_foodImageView addGestureRecognizer:singleTapGestureRecognizer];
        [_foodImageView setUserInteractionEnabled:YES];

        [self.view addSubview:_foodImageView];
        [self.view addSubview:_originalCommentLabel];
        [self.view addSubview:_scordLabel];
        [self.view addSubview:_commentListTableView];

        _otherComments = [[NSMutableArray alloc] init];

        [self fetchOrderDetail:item];
    }

    return self;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //load food image
    [self.foodImageView setImage:[UIImage imageNamed:@"image/03.jpg"]];

    //load score
    self.scordLabel.text = [@(self.badOrderItem.score) stringValue];
    self.scordLabel.textColor = [UIColor redColor];
    self.scordLabel.font = [UIFont systemFontOfSize:18];
    [self.scordLabel sizeToFit];
    [Views locate:self.scordLabel y:[Views bottomOf:self.foodImageView]];

    UILabel* posterLabel = [[UILabel alloc] init];
    posterLabel.text = self.badOrderItem.poster;
    posterLabel.textColor = [UIColor blackColor];
    posterLabel.font = [UIFont systemFontOfSize:18];
    [posterLabel sizeToFit];
    [Views locate:posterLabel x:[Views rightOf:self.scordLabel] y:self.scordLabel.frame.origin.y];
    [self.view addSubview:posterLabel];

    UILabel* commentLabel = [[UILabel alloc] init];
    commentLabel.text = self.badOrderItem.comment;
    commentLabel.textColor = [UIColor blackColor];
    commentLabel.font = [UIFont systemFontOfSize:20];
    [commentLabel sizeToFit];
    [Views locate:commentLabel x:10 y:[Views bottomOf:self.scordLabel]];
    [self.view addSubview:commentLabel];


    UILabel* otherCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [Views bottomOf:commentLabel], self.view.bounds.size.width, 60)];
    otherCommentLabel.text = [I18N key:@"other_comments"];
    otherCommentLabel.textColor = [UIColor grayColor];
    otherCommentLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:otherCommentLabel];

    [Views resize:self.commentListTableView
    containerSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - [Views bottomOf:otherCommentLabel])];
    [Views locate:self.commentListTableView y:[Views bottomOf:otherCommentLabel]];

    UIButton* stillBadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stillBadButton.tag = BAD_BUTTON_TAG;
    [stillBadButton setTitle:[I18N key:@"button_title_still_bad"] forState:UIControlStateNormal];
    [stillBadButton sizeToFit];
    [Views locate:stillBadButton x:10 y:[Views bottomOf:self.foodImageView] - stillBadButton.bounds.size.height - 10];
    [stillBadButton addTarget:self action:@selector(voteOrder:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stillBadButton];

    UIButton* notBadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    notBadButton.tag = NOT_BAD_BUTTON_TAG;
    [notBadButton setTitle:[I18N key:@"button_title_not_bad"] forState:UIControlStateNormal];
    [notBadButton sizeToFit];
    [notBadButton addTarget:self action:@selector(voteOrder:) forControlEvents:UIControlEventTouchUpInside];
    [Views locate:notBadButton x:self.foodImageView.bounds.size.width - notBadButton.bounds.size.width - 10
                y:stillBadButton.frame.origin.y];
    [self.view addSubview:notBadButton];
}

- (void) voteOrder:(UIButton*) sender
{
    //TODO - check login state
    PopupViewController* popupViewController = nil;
    MJPopupViewAnimation popupViewAnimation;
    if (BAD_BUTTON_TAG == sender.tag)
    {
        popupViewController = [[StillBadPopupController alloc] initStillBadPopup];
        popupViewAnimation = MJPopupViewAnimationSlideLeftLeft;
    }
    else
    {
        popupViewController = [[NotBadPopupController alloc] initNotBadPopup];
        popupViewAnimation = MJPopupViewAnimationSlideRightRight;
    }
    popupViewController.delegate = self;
    [self presentPopupViewController:popupViewController
                       animationType:popupViewAnimation];
}

- (void) submitButtonClicked:(PopupViewController*) secondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.otherComments = [[NSMutableArray alloc] init];
}

- (void) onTapImage
{
    NSLog(@">>>>>>>> OrderDetailController tap image");
}

- (void) fetchOrderDetail:(BadOrderItem*) item
{
    //TODO fecth all comment
    for (NSInteger i = 0; i < 10; ++i)
    {
        UserComment* comment = [[UserComment alloc] initUserCommentWithName:[NSString stringWithFormat:@"user %d", i]
                                                                    comment:[NSString stringWithFormat:@"comment %d", i]
                                                                      score:-1];
        [self.otherComments addObject:comment];
    }
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.otherComments.count;
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

    UserComment* comment = self.otherComments[(NSUInteger) indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = comment.name;
    cell.detailTextLabel.text = comment.comment;
    return cell;
}


@end