//
//  AuthenticationService.h
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AuthenticationStatus) {
    AuthenticationStatusUnknown,
    AuthenticationStatusNoSession,
    AuthenticationStatusValidSession,
    AuthenticationStatusTokenExpired
};


@interface AuthenticationService : NSObject

+ (void)configure;
+ (AuthenticationStatus)authenticationStatus;
+ (UIViewController *)authenticationController;
+ (void)startSessionWithUrl:(NSURL *)url;
+ (void)refreshToken;
+ (NSString *)accessToken;

+ (void)subscribeObserverForRefreshTokenSucces:(id)observer andSelector:(SEL)aSelector;
+ (void)subscribeObserverForRefreshTokenFailure:(id)observer andSelector:(SEL)aSelector;
+ (void)subscribeObserverForStartSessionSucces:(id)observer andSelector:(SEL)aSelector;
+ (void)subscribeObserverForStartSessionFailure:(id)observer andSelector:(SEL)aSelector;
+ (void)unsubscribeObserverFromAllNotifications:(id)observer;

@end
