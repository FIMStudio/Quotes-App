//
//  FIMQuote.h
//  Quotes
//
//  Created by Georgy Savatkov on 6/22/14.
//  Copyright (c) 2014 FIM Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIMQuote : NSObject
@property(strong, nonatomic) NSNumber *Id;
@property(strong, nonatomic) NSString *Author;
@property(strong, nonatomic) NSString *Text;
-(id)init:(NSNumber *)id : (NSString *) author : (NSString *) text;
@end
