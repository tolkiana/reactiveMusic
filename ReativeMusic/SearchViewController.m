//
//  SearchViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "SearchViewController.h"
#import "AuthenticationService.h"
#import <SpotifyMetadata/SpotifyMetadata.h>

static NSString * const kTrackCellIdentifier = @"TrackCellIdentifier";

@interface SearchViewController ()

@property (nonatomic, strong) NSArray<SPTPartialTrack *> *playlists;

@end

@implementation SearchViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self searchWithString:@"Bulls on parade"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
         
         SPTListPage *resultsPage = (SPTListPage *)object;
         self.playlists = [resultsPage items];
         [self.tableView reloadData];
     }];
}


@end
