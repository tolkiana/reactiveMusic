//
//  TrackSearchViewModel.h
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPTPartialTrack;
@interface TrackSearchViewModel : NSObject

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *tracKName;

- (instancetype)initWithTrackName:(NSString *)trackName
                    andArtistName:(NSString *)artistName;

- (instancetype)initWithPartialTrack:(SPTPartialTrack *)partialTrack;

@end