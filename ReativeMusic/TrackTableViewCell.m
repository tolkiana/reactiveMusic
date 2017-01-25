//
//  TrackTableViewCell.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "TrackTableViewCell.h"
#import "TrackViewModel.h"

@interface TrackTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *artistName;

@end

@implementation TrackTableViewCell

- (void)configureWithViewModel:(TrackViewModel *)TrackViewModel {
    self.trackTitle.text = TrackViewModel.tracKName;
    self.artistName.text = TrackViewModel.artistName;
}

@end
