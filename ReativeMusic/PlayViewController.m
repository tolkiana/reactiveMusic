//
//  PlayViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "PlayViewController.h"
#import "TrackViewModel.h"
#import <WebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyMetadata/SpotifyMetadata.h>

static NSString * const kPauseImageName = @"pause_button";
static NSString * const kPlayImageName = @"play_button";

@interface PlayViewController ()

@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *artistName;
@property (strong, nonatomic) IBOutlet UIImageView *albumImage;

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UISlider *progessBar;


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
    [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateSelected];
    [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    [self.albumImage sd_setImageWithURL:self.trackViewModel.albumImageURL];
}

- (IBAction)pausePlayButton:(UIButton *)button {
    button.selected = !button.selected;
}

@end
