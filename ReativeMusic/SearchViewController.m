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

@interface SearchViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSArray<TrackSearchViewModel *> *tracks;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SearchViewController

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSearchController];
}

#pragma mark - Views Setup

- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
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

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [self searchWithString:searchString];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {

}

#pragma mark - Search Methods

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
         self.tracks = [self tracksWithResults:object];
         [self.tableView reloadData];
     }];
}

- (NSArray<TrackSearchViewModel *> *)tracksWithResults:(SPTListPage *)results {
    NSArray<SPTPartialTrack *> *trackResults = [results items];
    NSMutableArray<TrackSearchViewModel *> *models = [NSMutableArray new];
    for (SPTPartialTrack *trackResult in trackResults) {
        TrackSearchViewModel *model = [[TrackSearchViewModel alloc] initWithPartialTrack:trackResult];
        [models addObject:model];
    }
    return models;
}




@end
