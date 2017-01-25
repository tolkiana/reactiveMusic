//
//  SearchService.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "SearchService.h"
#import "TrackViewModel.h"
#import "AuthenticationService.h"
#import <SpotifyMetadata/SpotifyMetadata.h>

@implementation SearchService

+ (void)searchWithString:(NSString *)string
          withCompletion:(void (^)(NSArray<TrackViewModel *> *))completion {
    
    SPTSearchQueryType queryType = SPTQueryTypeTrack;
    
    [SPTSearch performSearchWithQuery:string
                            queryType:queryType
                          accessToken:[AuthenticationService accessToken]
                             callback:^(NSError *error, id object) {
                                 if( error ) {
                                     completion(nil);
                                 }
                                 completion([self tracksWithResults:object]);
                             }];
}

+ (NSArray<TrackViewModel *> *)tracksWithResults:(SPTListPage *)results {
    NSArray<SPTPartialTrack *> *trackResults = [results items];
    NSMutableArray<TrackViewModel *> *models = [NSMutableArray new];
    for (SPTPartialTrack *trackResult in trackResults) {
        TrackViewModel *model = [[TrackViewModel alloc] initWithPartialTrack:trackResult];
        [models addObject:model];
    }
    return models;
}

@end
