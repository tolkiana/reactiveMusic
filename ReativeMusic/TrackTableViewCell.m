//
//  TrackTableViewCell.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "TrackTableViewCell.h"
#import "TrackSearchViewModel.h"

@interface TrackTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *artistName;

@end

@implementation TrackTableViewCell

- (void)configureWithViewModel:(TrackSearchViewModel *)trackSearchViewModel {
    self.trackTitle.text = trackSearchViewModel.tracKName;
    self.artistName.text = trackSearchViewModel.artistName;
}

@end
