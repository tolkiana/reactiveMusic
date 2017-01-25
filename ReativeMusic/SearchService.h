//
//  SearchService.h
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrackViewModel;
@interface SearchService : NSObject

+ (void)searchWithString:(NSString *)string
          withCompletion:(void (^)(NSArray<TrackViewModel *> *))completion;

@end
