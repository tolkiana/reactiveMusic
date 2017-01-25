//
//  SearchViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "SearchViewController.h"
#import "AuthenticationService.h"
#import "TrackSearchViewModel.h"
#import "TrackTableViewCell.h"
#import <SpotifyMetadata/SpotifyMetadata.h>

static NSString * const kTrackCellIdentifier = @"TrackCellIdentifier";

@interface SearchViewController ()

@property (nonatomic, strong) NSArray<TrackSearchViewModel *> *tracks;

@end

@implementation SearchViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self searchWithString:@"Bulls on parade"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackCellIdentifier
                                                            forIndexPath:indexPath];
    TrackSearchViewModel *trackViewModel = [self.tracks objectAtIndex:indexPath.row];
    [cell configureWithViewModel:trackViewModel];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchWithString:(NSString *)string {
    
    SPTSearchQueryType queryType = SPTQueryTypeTrack;
    
    [SPTSearch performSearchWithQuery:string
                            queryType:queryType
                          accessToken:[AuthenticationService accessToken]
                             callback:^(NSError *error, id object) {
         if( error ) {
             NSLog(@"Search error: %@", error );
             return;
         }
         self.tracks = [self tracksArrayWithResults:object];
         [self.tableView reloadData];
     }];
}

- (NSArray<TrackSearchViewModel *> *)tracksArrayWithResults:(SPTListPage *)results {
    NSArray<SPTPartialTrack *> *trackResults = [results items];
    NSMutableArray<TrackSearchViewModel *> *models = [NSMutableArray new];
    for (SPTPartialTrack *trackResult in trackResults) {
        TrackSearchViewModel *model = [[TrackSearchViewModel alloc] initWithPartialTrack:trackResult];
        [models addObject:model];
    }
    return models;
}




@end
