//
//  PlayViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "PlayViewController.h"
#import "TrackViewModel.h"

@interface PlayViewController ()

@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *artistName;
@property (strong, nonatomic) IBOutlet UIImageView *albumImage;

@end

@implementation PlayViewController

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

#pragma mark - Views Setup

- (void)setupViews {
    self.trackTitle.text = self.trackViewModel.tracKName;
    self.artistName.text = self.trackViewModel.artistName;
}


@end
