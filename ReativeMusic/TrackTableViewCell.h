//
//  TrackTableViewCell.h
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackViewModel;
@interface TrackTableViewCell : UITableViewCell

- (void)configureWithViewModel:(TrackViewModel *)TrackViewModel;

@end
