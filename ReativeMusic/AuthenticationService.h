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

static NSString * const kAuthenticationNotificationRefreshTokenSuccess = @"AuthenticationNotificationRefreshTokenSuccess";
static NSString * const kAuthenticationNotificationStartSessionSuccess = @"AuthenticationNotificationStartSessionSuccess";
static NSString * const kAuthenticationNotificationRefreshTokenFailure = @"AuthenticationNotificationRefreshTokenFailure";
static NSString * const kAuthenticationNotificationStartSessionFailure = @"AuthenticationNotificationStartSessionFailure";


@interface AuthenticationService : NSObject

+ (void)configure;
+ (AuthenticationStatus)authenticationStatus;
+ (UIViewController *)authenticationController;
+ (void)startSessionWithUrl:(NSURL *)url;
+ (void)refreshToken;
+ (NSString *)accessToken;
+ (NSString *)clientID;
+ (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void (^)(BOOL))block;

@end
