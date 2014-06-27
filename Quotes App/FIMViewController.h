//
//  FIMViewController.h
//  Quotes App
//
//  Created by Georgy Savatkov on 6/24/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIMMainController.h"
@interface FIMViewController : UIViewController
{
    int _viewedQuotes;
}
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *bgLabel;
@property(strong, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property(strong, nonatomic) UISwipeGestureRecognizer *swipeDown;
@property(strong, nonatomic) UISwipeGestureRecognizer *swipeUp;
@property(strong, nonatomic) FIMMainController *controller;
@property(strong, nonatomic) NSMutableArray *quotes;
@property (nonatomic, strong) NSMutableArray *labelColors;
@end
