#import "create_action_bar.h"

@implementation CreateActionBarViewController
@synthesize actionBar = _actionBar;
@synthesize entity = _entity;
// begin-simple-create-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
        
        SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
        shareOptions.dontShareLocation = YES;
        
        shareOptions.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
            if (network == SZSocialNetworkTwitter) {
                NSString *entityURL = [[postData.propagationInfo objectForKey:@"twitter"] objectForKey:@"entity_url"];
                NSString *displayName = [postData.entity displayName];
                NSString *customStatus = [NSString stringWithFormat:@"Custom status for %@ with url %@", displayName, entityURL];
                
                [postData.params setObject:customStatus forKey:@"status"];
                
            } else if (network == SZSocialNetworkFacebook) {
                NSString *entityURL = [[postData.propagationInfo objectForKey:@"facebook"] objectForKey:@"entity_url"];
                NSString *displayName = [postData.entity displayName];
                NSString *customMessage = [NSString stringWithFormat:@"Custom status for %@ ", displayName];
                
                [postData.params setObject:customMessage forKey:@"message"];
                [postData.params setObject:entityURL forKey:@"link"];
                [postData.params setObject:@"A caption" forKey:@"caption"];
                [postData.params setObject:@"Custom Name" forKey:@"name"];
                [postData.params setObject:@"A Site" forKey:@"description"];
            }
        };
        
        self.actionBar.shareOptions = shareOptions;
    }
}

@end

// end-simple-create-snippet

@implementation CreateActionBarViewController (AsViewDefaultFrame)


// begin-default-view-create-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectNull entity:self.entity viewController:self];
        [self.view addSubview:self.actionBar];
    }
}

// end-default-view-create-snippet

@end

@implementation CreateActionBarViewController (AsViewTopFrame)


// begin-top-view-create-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectZero entity:self.entity viewController:self];
        self.actionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.actionBar];
    }
}

// end-top-view-create-snippet

@end

@implementation CreateActionBarViewController (CustomButtons)

// begin-customize-buttons-create-snippet

- (void)emailButtonPressed:(id)sender {
    [SZShareUtils shareViaEmailWithViewController:self options:nil entity:self.entity success:nil failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectNull entity:self.entity viewController:self];
        
        SZActionButton *panicButton = [SZActionButton actionButtonWithIcon:nil title:@"Panic"];
        panicButton.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
        };
        
        self.actionBar.itemsRight = [NSArray arrayWithObjects:panicButton, [SZActionButton commentButton], nil];
        
        UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [emailButton setImage:[UIImage imageNamed:@"socialize-selectnetwork-email-icon.png"] forState:UIControlStateNormal];
        [emailButton sizeToFit];
        [emailButton addTarget:self action:@selector(emailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.actionBar.itemsLeft = [NSArray arrayWithObjects:[SZActionButton viewsButton], emailButton, nil];
        
        [self.view addSubview:self.actionBar];
    }
}

// end-customize-buttons-create-snippet

@end

@implementation CreateActionBarViewController (CustomImage)

// begin-customize-background-snippet

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectNull entity:self.entity viewController:self];
        
        UIImage *customBackground = [[UIImage imageNamed:@"action-bar-bg.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
        self.actionBar.backgroundImageView.image = customBackground;
        self.actionBar.backgroundImageView.alpha = 0.3f;
        
        [self.view addSubview:self.actionBar];
    }
}

// end-customize-background-snippet

@end

