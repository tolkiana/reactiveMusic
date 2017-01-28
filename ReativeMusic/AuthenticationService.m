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

static NSString * const kAuthenticationNotificationRefreshTokenSuccess = @"AuthenticationNotificationRefreshTokenSuccess";
static NSString * const kAuthenticationNotificationStartSessionSuccess = @"AuthenticationNotificationStartSessionSuccess";
static NSString * const kAuthenticationNotificationRefreshTokenFailure = @"AuthenticationNotificationRefreshTokenFailure";
static NSString * const kAuthenticationNotificationStartSessionFailure = @"AuthenticationNotificationStartSessionFailure";


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

+ (void)startSessionWithUrl:(NSURL *)url {
    SPTAuth *auth = [SPTAuth defaultInstance];
    if ([auth canHandleURL:url]) {
        [auth handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationNotificationStartSessionFailure
                                                                    object:nil];
            } else {
                auth.session = session;
                [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationNotificationStartSessionSuccess
                                                                    object:nil];
            }
        }];
    }
}
+ (void)refreshToken {
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationNotificationRefreshTokenFailure
                                                                object:nil];
        } else {
            auth.session = session;
            [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationNotificationRefreshTokenSuccess
                                                                object:nil];
        }
    }];
}

+ (NSString *)accessToken {
    return [[[SPTAuth defaultInstance] session] accessToken];
}

#pragma mark - Notification methods

+ (void)subscribeObserverForRefreshTokenSucces:(id)observer andSelector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:kAuthenticationNotificationRefreshTokenSuccess
                                               object:nil];
}

+ (void)subscribeObserverForRefreshTokenFailure:(id)observer andSelector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:kAuthenticationNotificationRefreshTokenFailure
                                               object:nil];
}

+ (void)subscribeObserverForStartSessionSucces:(id)observer andSelector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:kAuthenticationNotificationStartSessionSuccess
                                               object:nil];
}

+ (void)subscribeObserverForStartSessionFailure:(id)observer andSelector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:kAuthenticationNotificationStartSessionFailure
                                               object:nil];
}

+ (void)unsubscribeObserverFromAllNotifications:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}



@end
