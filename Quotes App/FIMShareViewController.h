//
//  FIMShareViewController.h
//  Quotes App
//
//  Created by Georgy Savatkov on 6/24/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIMQuote.h"

@interface FIMShareViewController : UIViewController
-(IBAction)facebookBtn:(id)sender;
-(IBAction)twitterBtn:(id)sender;
-(IBAction)favoritesBtn:(id)sender;
-(IBAction)reloadBtn:(id)sender;
@property(strong, nonatomic) UIButton *facebookButton;
@property(strong, nonatomic) UIButton *twitterButton;
@property(strong, nonatomic) UIButton *favoritesButton;
@property(strong, nonatomic) UIButton *reloadButton;
@property (nonatomic) UIDynamicAnimator *animator;
@property(strong, nonatomic) FIMQuote *quote;
@property(strong, nonatomic) NSNumber *loadFlag; //1 - Share, 2 - Add to Favorites.
-(id)init:(FIMQuote *) quote : (NSNumber *) flag;
@end
