//
//  AuthenticationService.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "AuthenticationService.h"
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SafariServices/SafariServices.h>


static NSString * const kClientID = @"9c2c7d32399747ff9c9c4a7cc5e73a0f";
static NSString * const kRedirectURL = @"reactive-music://callback";
static NSString * const kSessionKey = @"ReactiveMusicSession";


@implementation AuthenticationService

+ (void)configure {
    SPTAuth *auth = [SPTAuth defaultInstance];
    auth.clientID = kClientID;
    auth.redirectURL = [NSURL URLWithString:kRedirectURL];
    auth.sessionUserDefaultsKey = kSessionKey;
    auth.requestedScopes = @[SPTAuthStreamingScope];
}

+ (AuthenticationStatus)authenticationStatus {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    // Check if we have a token at all
    if (auth.session == nil) {
        return AuthenticationStatusNoSession;
    }
    // Check if it's still valid
    if ([auth.session isValid]) {
        return AuthenticationStatusValidSession;
    }
    // Oh noes, the token has expired, if we have a token refresh service set up, we'll call tat one.
    if (auth.hasTokenRefreshService) {
        return AuthenticationStatusTokenExpired;
    }
    return AuthenticationStatusUnknown;
}

+ (UIViewController *)authenticationController {
    SPTAuth *auth = [SPTAuth defaultInstance];
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[auth spotifyWebAuthenticationURL]];
    safari.modalPresentationStyle = UIModalPresentationPageSheet;
    return safari;
}

+ (void)startAuthenticationWithUrl:(NSURL *)url andCompletion:(void (^)(NSError *))completion {
    SPTAuth *auth = [SPTAuth defaultInstance];
    if ([auth canHandleURL:url]) {
        [auth handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (error) {
                completion(error);
            } else {
                auth.session = session;
                completion(nil);
            }
        }];
    }
}
+ (void)renewTokenWithCompletion:(void (^)(NSError *))completion {
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
        if (error) {
            completion(error);
        } else {
            auth.session = session;
            completion(nil);
        }
    }];
}

@end
