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
#import "UIColor+Utilities.h"
#import <SpotifyMetadata/SpotifyMetadata.h>

static NSString * const kTrackCellIdentifier = @"TrackCellIdentifier";
static NSString * const kLightBlueColorHexString = @"#4091cb";
static NSString * const kBlueColorHexString = @"#286591";

@interface SearchViewController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSArray<TrackSearchViewModel *> *tracks;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SearchViewController

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchController];
    [self setupNatigationBar];
}

#pragma mark - Views Setup

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.barTintColor = [UIColor colorWithHexString:kBlueColorHexString];
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

- (void)setupNatigationBar {
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                               forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:kLightBlueColorHexString]];
    [[UINavigationBar appearance] setTitleTextAttributes: textAttributes];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self searchWithString:searchController.searchBar.text];
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
