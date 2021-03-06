//
//  SearchViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "SearchViewController.h"
#import "PlayViewController.h"
#import "TrackViewModel.h"
#import "TrackTableViewCell.h"
#import "UIColor+Utilities.h"
#import "AuthenticationService.h"
#import "SearchService.h"
#import <SpotifyMetadata/SpotifyMetadata.h>

static NSString * const kSegueDetailIdentifier = @"SegueDetailIdentifier";
static NSString * const kTrackCellIdentifier = @"TrackCellIdentifier";
static NSString * const kLightBlueColorHexString = @"#4091cb";
static NSString * const kBlueColorHexString = @"#286591";

@interface SearchViewController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSArray<TrackViewModel *> *tracks;
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
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
    TrackViewModel *trackViewModel = [self.tracks objectAtIndex:indexPath.row];
    [cell configureWithViewModel:trackViewModel];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSegueDetailIdentifier sender:self];
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueDetailIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PlayViewController *destinationController = segue.destinationViewController;
        destinationController.trackViewModel = [self.tracks objectAtIndex:indexPath.row];
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    [SearchService searchWithString:searchText withCompletion:^(NSArray<TrackViewModel *> *results) {
        self.tracks = results;
        [self.tableView reloadData];
    }];
}

@end
