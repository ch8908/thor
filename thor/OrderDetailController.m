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

@interface OrderDetailController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readonly) UITableView* commentListTableView;
@property (nonatomic, readwrite) UIImageView* foodImageView;
@property (nonatomic, readonly) UILabel* originalCommentLabel;
@property (nonatomic, readonly) UILabel* scordLabel;
@property (nonatomic) BadOrderItem* badOrderItem;
@end

@implementation OrderDetailController
@synthesize commentListTableView = _commentListTableView;
@synthesize originalCommentLabel = _originalCommentLabel;
@synthesize foodImageView = _foodImageView;
@synthesize scordLabel = _scordLabel;
@synthesize badOrderItem = _badOrderItem;

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
        _foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [ViewParams screenWidth], 260)];

        [self.view addSubview:_foodImageView];
        [self.view addSubview:_originalCommentLabel];
        [self.view addSubview:_scordLabel];
        [self.view addSubview:_commentListTableView];

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

}

- (void) fetchOrderDetail:(BadOrderItem*) item
{
    //TODO fecth all comment
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return 0;
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return nil;
}


@end