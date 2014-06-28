//
//  FIMViewController.m
//  Quotes App
//
//  Created by Georgy Savatkov on 6/24/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import "FIMViewController.h"
#import "FIMMainController.h"
#import "FIMQuote.h"
#import "FIMShareViewController.h"
#import "FIMPresentSahreViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Social/Social.h>
 #include <arpa/inet.h> 
#include <net/if.h> 
#include <ifaddrs.h> 
#include <net/if_dl.h>
@interface FIMViewController ()

@end

@implementation FIMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGuestures];
    [self initColors];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if (![self hasConnectivity]) {
        [self showShare:@2];
    }
    else if(self.quotes == nil){
        [self initUI];
        [self getQuotes];
    }
   
    // Init favoritesKey and favoritesKeyId
    if (self.favoritesKey == nil) {
        self.favoritesKey = @"quote";
        _favoritesKeyId = 0;
        
    }
   
    
    
}
-(void)getQuotes
{
    _viewedQuotes = 0;
    [self showLoading];
    NSString *serverURL = @"http://egorikem.byethost7.com/server/getquote.php?q=1";
    if ([self hasConnectivity]) {
        self.controller = [[FIMMainController alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.quotes = [self.controller getQuotes:serverURL:@8];
            [self hideLoading];
            [self upadateQuote];

        });
        
    }
    else {
        [self showShare:@3];
    }

#pragma -- Main init
    
}
-(void)showLoading
{
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    av.frame=CGRectMake([self getScreenWidth]/2-25, [self getScreenHeight]/2-25, 50, 50);
    av.tag  = 1;
    [self.view addSubview:av];
    [av startAnimating];
}
-(void)hideLoading
{
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [tmpimg removeFromSuperview];
}
-(FIMQuote *)getRandomQuote
{
    return [self.quotes objectAtIndex:arc4random() % [self.quotes count]];
}
-(void)upadateQuote
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.textLabel.alpha = 0.0;
                         self.authorLabel.alpha = 0.0;
                     }];
    FIMQuote *quote = [self getRandomQuote];
    self.textLabel.text = quote.Text;
    self.authorLabel.text = quote.Author;
    UIColor *randomColor = [self getRandomColor];
    while ((UIColor *)self.textLabel.backgroundColor == randomColor ) {
        randomColor = [self getRandomColor];
    }
    self.bgLabel.backgroundColor = randomColor;
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.textLabel.alpha = 1.0;
                         self.authorLabel.alpha = 1.0;
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

-(void)initUI
{
    self.bgLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, [self getScreenHeight]/2, [self getScreenWidth], 43.0) ];
    self.textLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, [self getScreenHeight]/2, [self getScreenWidth], 43.0) ];
    self.authorLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, [self getScreenHeight]/2, [self getScreenWidth], 43.0) ];
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.authorLabel.textAlignment = UITextAlignmentRight;
    self.textLabel.numberOfLines = @4;
    self.textLabel.textColor = [UIColor whiteColor];
    self.authorLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(18.0)];
    self.authorLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(15.0)];
    [self.view addSubview:self.bgLabel];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.authorLabel];
    if ((int) [[UIScreen mainScreen] bounds].size.height == 568) {
        self.bgLabel.frame = CGRectMake(0, 175, 320, 190);
        self.textLabel.frame = CGRectMake(5, 175, 310, 190);
        self.authorLabel.frame = CGRectMake(116, 367, 193, 26);
    }
    else {
        self.bgLabel.frame = CGRectMake(0, 145, 320, 190);
        self.textLabel.frame = CGRectMake(5, 145, 310, 190);
        self.authorLabel.frame = CGRectMake(116, 335, 193, 26);
    }


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initGuestures
{
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [self.swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    // Adding the swipe gesture
    [self.view addGestureRecognizer:self.swipeLeft];
    [self.view addGestureRecognizer:self.swipeDown];
    [self.view addGestureRecognizer:self.swipeUp];
}
#pragma mark - Work with swipe
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(_viewedQuotes < 10)
        {
           _viewedQuotes+=1;
            NSLog(@"%d", _viewedQuotes);
           [self upadateQuote];
        }
        else {
            if([self hasConnectivity])
            {
                _viewedQuotes = 0;
                [self getQuotes];
                _viewedQuotes+=1;
                [self upadateQuote];
            }
            else {
                [self showShare:@2];
            }
        }
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        [self showShare:@1];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [self addToFavorites];
        NSLog(@"add to favorites! And ... some debug info:");
        NSLog(@"quote: %@", self.textLabel.text);
        NSLog(@"Favorites quote %@", self.favorites);
        NSLog(@"favoritesKeyId %@", [self favoritesKeyGet]);
        
    }
    
}

// Label Colors
-(void)initColors {
    self.labelColors = [NSMutableArray arrayWithObjects:
                        [UIColor colorWithRed:111/255.0 green:181/255.0 blue:162/255.0 alpha:1],
                        [UIColor colorWithRed:252/255.0 green:167/255.0 blue:84/255.0 alpha:1],
                        [UIColor colorWithRed:177/255.0 green:97/255.0 blue:110/255.0 alpha:1],
                        [UIColor colorWithRed:234/255.0 green:105/255.0 blue:103/255.0 alpha:1],
                        [UIColor colorWithRed:253/255.0 green:194/255.0 blue:85/255.0 alpha:1],
                        [UIColor colorWithRed:224/255.0 green:130/255.0 blue:115/255.0 alpha:1],
                        [UIColor colorWithRed:125/255.0 green:111/255.0 blue:181/255.0 alpha:1],
                        [UIColor colorWithRed:191/255.0 green:164/255.0 blue:206/255.0 alpha:1],
                        [UIColor colorWithRed:73/255.0 green:164/255.0 blue:184/255.0 alpha:1],
                        [UIColor colorWithRed:155/255.0 green:147/255.0 blue:239/255.0 alpha:1],
                        nil];
}

-(UIColor *)getRandomColor {
    return [self.labelColors objectAtIndex:(arc4random()%self.labelColors.count)];
}

-(void)showShare : (NSNumber *) flag;
{
    FIMShareViewController *shareController = [[FIMShareViewController alloc]init:[[FIMQuote alloc]init:@0 :self.authorLabel.text :self.textLabel.text]:flag];
    shareController.modalPresentationStyle = UIModalPresentationCustom;
    shareController.transitioningDelegate = self;
    [self presentViewController:shareController animated:YES completion:nil];

}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[FIMPresentSahreViewController alloc] init];
}


-(void)addToFavorites {
    _favorites = @{[self favoritesKeyGet]:self.textLabel.text};
    _favoritesKeyId++;
    
}

-(NSString *)favoritesKeyGet
{
     return [self.favoritesKey stringByAppendingString:[NSString stringWithFormat:@"%i", _favoritesKeyId]];
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
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
