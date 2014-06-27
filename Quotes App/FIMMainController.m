//
//  FIMMainController.m
//  Quotes
//
//  Created by Georgy Savatkov on 6/22/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import "FIMMainController.h"
#import "FIMQuote.h"
#import <Social/Social.h>
#import <UIKit/UIKit.h>
@implementation FIMMainController
-(NSMutableArray *)getQuotes: (NSString *)urlAddress : (NSNumber *)amout
{
    NSMutableArray *output = [[NSMutableArray alloc]init];
    NSString *string= [[NSString alloc]initWithFormat:urlAddress];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];//response object is your response from server as NSData
    if ([json isKindOfClass:[NSDictionary class]]) { //Added instrospection as suggested in comment.
            NSArray *yourStaffDictionaryArray = json[@"results"];
            if ([yourStaffDictionaryArray isKindOfClass:[NSArray class]]){//Added instrospection as suggested in comment.
                for (NSDictionary *dictionary in yourStaffDictionaryArray) {
                    if(_quotesAmout < [amout integerValue]) {
                        FIMQuote *quote = [[FIMQuote alloc] init:[dictionary objectForKey:@"Id"] :[dictionary objectForKey:@"author"] :[dictionary objectForKey:@"text"]];
                        _quotesAmout+=1;
                        [output addObject:quote];
                    }
                }
            }
    }
    return output;
}

@end
