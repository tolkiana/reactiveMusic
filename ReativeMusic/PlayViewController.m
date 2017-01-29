//
//  PlayViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "PlayViewController.h"
#import "TrackViewModel.h"
#import "AuthenticationService.h"
#import <WebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyMetadata/SpotifyMetadata.h>

static NSString * const kPauseImageName = @"pause_button";
static NSString * const kPlayImageName = @"play_button";

@interface PlayViewController ()<SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>

@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *artistName;
@property (strong, nonatomic) IBOutlet UIImageView *albumImage;

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UISlider *progessBar;

@property (strong, nonatomic) SPTAudioStreamingController *player;

@end

@implementation PlayViewController

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupPlayer];
}

#pragma mark - IBActions

- (IBAction)pausePlayButton:(UIButton *)button {
    button.selected = !button.selected;
    [self.player setIsPlaying:!self.player.playbackState.isPlaying callback:nil];
}

#pragma mark - Views Setup

- (void)setupViews {
    self.trackTitle.text = self.trackViewModel.tracKName;
    self.artistName.text = self.trackViewModel.artistName;
    [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateSelected];
    [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    [self.albumImage sd_setImageWithURL:self.trackViewModel.albumImageURL];
}

#pragma mark - Player

- (void)setupPlayer {
    NSError *error = nil;
    self.player = [SPTAudioStreamingController sharedInstance];
    if ([self.player startWithClientId:[AuthenticationService clientID] error:&error]) {
        self.player.delegate = self;
        self.player.playbackDelegate = self;
        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024*1024*64];
        [self.player loginWithAccessToken:[AuthenticationService accessToken]];
    }
    else if (self.player.playbackState.isPlaying){
        self.player.playbackDelegate = self;
        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024*1024*64];
        [self startPlayingTrack];
    }
}

- (void)startPlayingTrack {
    [self.player playSpotifyURI:self.trackViewModel.spotifyURI
              startingWithIndex:0
           startingWithPosition:0
                       callback:^(NSError *error) {
                           if(error != nil) {
                               NSLog(@"Error playing");
                               return;
                           }
    }];
}

#pragma mark - SPTAudioStreamingController

- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
    [self startPlayingTrack];
}

#pragma mark - SPTAudioStreamingPlaybackDelegate

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming
     didChangePosition:(NSTimeInterval)position {
    self.progessBar.value = position/self.player.metadata.currentTrack.duration;
}

@end
