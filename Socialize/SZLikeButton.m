//
//  SZLikeButton.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZLikeButton.h"
#import "SocializeUserService.h"
#import "SocializeEntityService.h"
#import "SocializeLikeService.h"
#import "NSNumber+Additions.h"
#import "SDKHelpers.h"
#import "SZLikeUtils.h"
#import "SZActionButton_Private.h"
#import "SZEntityUtils.h"
#import "socialize_globals.h"

@interface SZLikeButton ()

@property (nonatomic, getter=isLiked) BOOL liked;
@property (nonatomic, retain) id<SZEntity> serverEntity;

@end

@implementation SZLikeButton
@synthesize inactiveImage = inactiveImage_;
@synthesize inactiveHighlightedImage = inactiveHighlightedImage_;
@synthesize activeImage = activeImage_;
@synthesize activeHighlightedImage = activeHighlightedImage_;
@synthesize likedIcon = likedIcon_;
@synthesize unlikedIcon = unlikedIcon_;
@synthesize viewController = viewController_;
@synthesize liked = liked_;
@synthesize entity = _entity;
@synthesize serverEntity = _serverEntity;
@synthesize hideCount = hideCount_;
@synthesize failureRetryInterval = _failureRetryInterval;

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)viewController {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButtonBackgroundImages];
        
        self.actualButton.accessibilityLabel = @"like button";

        self.viewController = viewController;
        
        self.entity = entity;
        
    }
    return self;
}

- (void)resetButtonsToDefaults {
    [super resetButtonsToDefaults];
    self.inactiveImage = [[self class] defaultInactiveImage];
    self.inactiveHighlightedImage = [[self class] defaultInactiveHighlightedImage];
    self.activeImage = [[self class] defaultActiveImage];
    self.activeHighlightedImage = [[self class] defaultActiveHighlightedImage];
    self.likedIcon = [[self class] defaultLikedIcon];
    self.unlikedIcon = [[self class] defaultUnlikedIcon];
}

- (void)configureForNewServerEntity:(id<SocializeEntity>)serverEntity {

    if (!self.hideCount) {
        NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:serverEntity.likes] ceiling:[NSNumber numberWithInt:1000]]; 
        [self setTitle:formattedValue];
    }
    
    if ([serverEntity userActionSummary] != nil) {
        self.liked = SZEntityIsLiked(serverEntity);
    }

    [self configureButtonBackgroundImages];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
}

- (UIImage*)icon {
    if (self.isLiked) {
        return self.likedIcon;
    } else {
        return self.unlikedIcon;
    }
}

- (void)failWithError:(NSError*)error {
    SZEmitUIError(self, error);
}

+ (NSTimeInterval)defaultFailureRetryInterval {
    return 10;
}

+ (UIImage*)defaultInactiveImage {
    return [[UIImage imageNamed:@"action-bar-button-black.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultInactiveHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-black-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultActiveImage {
    return [[UIImage imageNamed:@"action-bar-button-red.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultActiveHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-red-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultLikedIcon {
    return [UIImage imageNamed:@"action-bar-icon-liked.png"];
}

+ (UIImage*)defaultUnlikedIcon {
    return [UIImage imageNamed:@"action-bar-icon-like.png"];
}

- (void)setLikedIcon:(UIImage*)likedIcon {
    likedIcon_ = likedIcon;
    [self configureButtonBackgroundImages];
}

- (void)setUnlikedIcon:(UIImage*)unlikedIcon {
    unlikedIcon_ = unlikedIcon;
    [self configureButtonBackgroundImages];
}

- (void)setInactiveImage:(UIImage *)inactiveImage {
    inactiveImage_ = inactiveImage;
    [self configureButtonBackgroundImages];
}

- (void)setInactiveHighlightedImage:(UIImage *)inactiveHighlightedImage {
    inactiveHighlightedImage_ = inactiveHighlightedImage;
    [self configureButtonBackgroundImages];
}

- (void)setActiveImage:(UIImage *)activeImage {
    activeImage_ = activeImage;
    [self configureButtonBackgroundImages];
}

- (void)setActiveHighlightedImage:(UIImage *)activeHighlightedImage {
    activeHighlightedImage_ = activeHighlightedImage;
    [self configureButtonBackgroundImages];
}

- (void)configureButtonBackgroundImages {
    [self.actualButton setBackgroundImage:self.disabledImage forState:UIControlStateDisabled];
    
    if (self.isLiked) {
        [self.actualButton setBackgroundImage:self.activeImage forState:UIControlStateNormal];
        [self.actualButton setBackgroundImage:self.activeHighlightedImage forState:UIControlStateHighlighted];
        [self.actualButton setImage:self.likedIcon forState:UIControlStateNormal];
    } else {
        [self.actualButton setBackgroundImage:self.inactiveImage forState:UIControlStateNormal];
        [self.actualButton setBackgroundImage:self.inactiveHighlightedImage forState:UIControlStateHighlighted];        
        [self.actualButton setImage:self.unlikedIcon forState:UIControlStateNormal];
    }
    
}

- (void)unlikeOnServer {
    self.actualButton.enabled = NO;
    
    [SZLikeUtils unlike:self.entity success:^(id<SZLike> like) {
        self.liked = NO;
        self.actualButton.enabled = YES;
        [self configureForNewServerEntity:like.entity];
        [self configureButtonBackgroundImages];
        [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
    } failure:^(NSError *error) {
        self.actualButton.enabled = YES;
        [self failWithError:error];
    }];
}

- (void)likeOnServer {
    self.actualButton.enabled = NO;

    [SZLikeUtils likeWithViewController:self.viewController options:self.likeOptions entity:self.entity success:^(id<SZLike> like) {

        // Like succeeded
        self.liked = YES;
        self.actualButton.enabled = YES;
        [self configureForNewServerEntity:like.entity];
        [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
        
    } failure:^(NSError *error) {
        
        // Like failed
        self.actualButton.enabled = YES;
        
        if (![error isSocializeErrorWithCode:SocializeErrorLikeCancelledByUser]) {
            [self failWithError:error];
        }
    }];
}

- (void)toggleLikeState {
    if (self.isLiked) {
        [self unlikeOnServer];
    } else {
        [self likeOnServer];
    }
}

- (void)handleButtonPress:(id)sender {
    [self toggleLikeState];
}


- (void)setEntity:(id<SocializeEntity>)entity {
    
    // Require explicit refresh for now
    if ([entity isEqual:_entity]) {
        return;
    }
    
    _entity = entity;
    
    if (_entity == nil) {
        return;
    }
    
    // This is the user-set entity property. The server entity is always stored in self.serverEntity
    if (![entity isFromServer] || [entity userActionSummary] == nil) {
        [self refresh];
    } else {
        [self configureForNewServerEntity:entity];
    }
}

- (BOOL)initialized {
    return self.serverEntity != nil;
}

- (void)actionBar:(SZActionBar *)actionBar didLoadEntity:(id<SocializeEntity>)entity {
    self.entity = entity;
}

- (void)refresh {
    self.liked = NO;
    self.serverEntity = nil;
    self.actualButton.enabled = NO;
    
    [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> entity) {
        self.actualButton.enabled = YES;
        [self configureForNewServerEntity:entity];
    } failure:^(NSError *error) {
        SZEmitUIError(self, error);
    }];
}

@end
