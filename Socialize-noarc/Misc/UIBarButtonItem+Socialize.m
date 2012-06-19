//
//  UIBarButtonItem+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/29/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UIBarButtonItem+Socialize.h"

@implementation UIBarButtonItem (Socialize)

- (void)changeTitleOnCustomButtonToText:(NSString*)text {
    UIButton *button = (UIButton*)[self customView];
    if ([button isKindOfClass:[UIButton class]]) {
        [button configureWithTitle:text];
    }
}

@end