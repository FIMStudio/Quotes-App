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
        [self showShare:@3];
    }
    else {
        [self getQuotes];
    }
}
-(void)getQuotes
{
    
    NSString *serverURL = @"http://egorikem.byethost7.com/server/getquote.php?q=1";
    if ([self hasConnectivity]) {
        self.controller = [[FIMMainController alloc]init];
        self.quotes = [self.controller getQuotes:serverURL:@8];
        [self upadateQuote];
    }
    else {
        [self showShare:@3];
    }

#pragma -- Main init
    
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
    self.textLabel.backgroundColor = randomColor;
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.textLabel.alpha = 1.0;
                         self.authorLabel.alpha = 1.0;
                     }];
    
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
    
    // Setting the swipe direction.
    [self.swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    // Adding the swipe gesture
    [self.view addGestureRecognizer:self.swipeLeft];
    [self.view addGestureRecognizer:self.swipeDown];
}
#pragma mark - Work with swipe
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swipe"
//                                                        message:@"Swiped left"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
          [self upadateQuote];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        [self showShare:@1];
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
