//
//  FIMMainController.h
//  Quotes
//
//  Created by Georgy Savatkov on 6/22/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIMMainController : NSObject
{
    int _quotesAmout;
}
-(NSMutableArray *)getQuotes: (NSString *) urlAddress : (NSNumber *)amout;
@property (nonatomic, strong) NSMutableData *responseData;
@end
