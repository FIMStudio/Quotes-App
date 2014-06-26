//
//  FIMQuote.m
//  Quotes
//
//  Created by Georgy Savatkov on 6/22/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import "FIMQuote.h"

@implementation FIMQuote
-(id)init:(NSNumber *)id : (NSString *) author : (NSString *) text
{
    self = [super init];
    if(self)
    {
        _Id = id;
        _Author = author;
        _Text = text;
    }
    return self;
}
@end
