//
//  TrackSearchViewModel.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "TrackSearchViewModel.h"

@implementation TrackSearchViewModel

- (instancetype)initWithTrackName:(NSString *)trackName andArtistName:(NSString *)artistName {
    self = [super init];
    if (self) {
        _tracKName = trackName;
        _artistName = artistName;
    }
    return self;
}

@end
