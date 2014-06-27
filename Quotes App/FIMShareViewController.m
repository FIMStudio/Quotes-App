//
//  FIMShareViewController.m
//  Quotes App
//
//  Created by Georgy Savatkov on 6/24/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import "FIMShareViewController.h"
#import <Social/Social.h>

@interface FIMShareViewController ()

@end

@implementation FIMShareViewController

-(id)init:(FIMQuote *) quote : (NSNumber *) flag{
    self = [super init];
    if (self) {
        self.quote = quote;
        self.loadFlag = flag;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    if ([self.loadFlag integerValue]  == 1) {
        [self loadViewShare:@"facebook":@"twitter":96.0f:20.0f];
    }
    else if([self.loadFlag integerValue]  == 2)
    {
        [self loadViewAlert:@"error" : @"reload" : 96.0f : 54.0f];
        [self showAlert:@"You are not connected to the internet"];
    }
    UISwipeGestureRecognizer *swipeUp= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUp];
    // Do any additional setup after loading the view.
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp && [self.loadFlag integerValue] != 3) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swipe"
        //                                                        message:@"Swiped down"
        //                                                       delegate:self
        //                                              cancelButtonTitle:@"OK"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        [self close];
        
    }
    
}

-(void)loadViewShare:(NSString *)facebookImage : (NSString *) twitterImage : (float)btnSize : (float)btnMargin
{
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.twitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.facebookButton addTarget:self
               action:@selector(facebookBtn:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //
    [self.twitterButton addTarget:self
                       action:@selector(twitterBtn:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.facebookButton setBackgroundImage:[UIImage imageNamed:facebookImage] forState:UIControlStateNormal];
    
    [self.twitterButton setBackgroundImage:[UIImage imageNamed:twitterImage] forState:UIControlStateNormal];
    
    [self.facebookButton setContentMode:UIViewContentModeCenter];
    [self.twitterButton setContentMode:UIViewContentModeCenter];
    
    self.facebookButton.frame = CGRectMake(self.view.bounds.size.width/2-btnSize-btnMargin/2, self.view.bounds.size.height/2-btnSize/2, btnSize, btnSize);
    self.twitterButton.frame = CGRectMake(self.view.bounds.size.width/2+btnMargin/2, self.view.bounds.size.height/2-btnSize/2, btnSize, btnSize);

    [self.view addSubview:self.facebookButton];
    [self.view addSubview:self.twitterButton];
}


-(void)loadViewAlert:(NSString *)alertImage : (NSString *)reloadImage : (float)alertBtnSize : (float)reloadBtnSize
{
    // Init a button premitive
    self.favoritesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // Add action
    [self.favoritesButton addTarget:self
                             action:@selector(alertBtn:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.reloadButton addTarget:self
                             action:@selector(reloadBtn:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    // Set bg
    [self.favoritesButton setBackgroundImage:[UIImage imageNamed:alertImage] forState:UIControlStateNormal];
    [self.reloadButton setBackgroundImage:[UIImage imageNamed:reloadImage] forState:UIControlStateNormal];
    // Align center bg
    [self.favoritesButton setContentMode:UIViewContentModeCenter];
    [self.reloadButton setContentMode:UIViewContentModeCenter];
    // Create frame and align
    self.favoritesButton.frame = CGRectMake(self.view.bounds.size.width/2-alertBtnSize/2, self.view.bounds.size.height/2-alertBtnSize/2-50.0, alertBtnSize, alertBtnSize);
    self.reloadButton.frame = CGRectMake(self.view.bounds.size.width/2-reloadBtnSize/2, self.view.bounds.size.height/2+reloadBtnSize, reloadBtnSize, reloadBtnSize);
    // Add
    [self.view addSubview:self.favoritesButton];
    [self.view addSubview:self.reloadButton];
    
}

-(void)showAlert:(NSString *)alertText
{
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, [self getScreenHeight]/2, [self getScreenWidth], 43.0) ];
    scoreLabel.textAlignment = UITextAlignmentCenter;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(18.0)];
    scoreLabel.text = alertText;
    [self.view addSubview:scoreLabel];
    
}
- (void)close {
        
    [UIView animateWithDuration:0.3
                     animations:^{self.view.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }];
}

-(float)getScreenWidth
{
    return (float) [[UIScreen mainScreen] bounds].size.width;
}
-(float)getScreenHeight
{
    return (float) [[UIScreen mainScreen] bounds].size.height;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)facebookBtn:(id)sender
{
 
    [self shareOnFaceBook];

}
-(IBAction)twitterBtn:(id)sender
{
    
    [self shareOnTwitter];

}

-(IBAction)favoritesBtn:(id)sender
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:self.quote forKey:@"accessToken"];
//    [userDefault synchronize];
}
-(IBAction)alertBtn:(id)sender
{
    // Do some code
}
-(IBAction)reloadBtn:(id)sender
{
    if([self hasConnectivity]) {
        [self close];
    }
}


#pragma mark -Sharing
-(bool)shareOnTwitter
{
    SLComposeViewController *twitterComposeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    // Shortened URL
    NSURL *url = [NSURL URLWithString:@"http://mylittlefacewhen.com"];
    
    // Adding the URL
    [twitterComposeController addURL:url];
    
    // Adding the dummy text
    [twitterComposeController setInitialText:[self.quote.Text stringByAppendingString:@"\nShared via Quotes(c)"]];
    
    [self presentViewController:twitterComposeController animated:YES completion:^{
    }];
    
    return true;
}
-(bool)shareOnFaceBook
{
    SLComposeViewController *facebookComposeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    // Shortened URL
    NSURL *url = [NSURL URLWithString:@"http://mylittlefacewhen.com"];
    
    // Adding the URL
    [facebookComposeController addURL:url];
    
    // Adding the dummy text
    [facebookComposeController setInitialText:[self.quote.Text stringByAppendingString:@"\nShared via Quotes(c)"]];
    
    [self presentViewController:facebookComposeController animated:YES completion:^{
    }];
    return true;
}

#pragma --Check internet
-(bool)hasConnectivity
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
        return true;
    else
        return false;
}
@end
