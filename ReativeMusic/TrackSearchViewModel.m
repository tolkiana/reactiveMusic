//
//  TrackSearchViewModel.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "TrackSearchViewModel.h"
#import <SpotifyMetadata/SpotifyMetadata.h>

@implementation TrackSearchViewModel

- (instancetype)initWithTrackName:(NSString *)trackName andArtistName:(NSString *)artistName {
    self = [super init];
    if (self) {
        _tracKName = trackName;
        _artistName = artistName;
    }
    return self;
}

- (instancetype)initWithPartialTrack:(SPTPartialTrack *)partialTrack {
    self = [super init];
    if (self) {
        SPTPartialArtist *artist = partialTrack.artists.firstObject;
        _tracKName = partialTrack.name;
        _artistName = artist.name;
        _albumImageURL = partialTrack.album.largestCover.imageURL;
    }
    return self;
}

@end
