//
//  ScheduleFetcher.h
//  RanchForecast
//
//  Created by Meng Li on 14-7-18.
//  Copyright (c) 2014年 Meng Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ScheduleFetcherResultBlock)(NSArray *classes, NSError *error);

@interface ScheduleFetcher : NSObject
<NSXMLParserDelegate> {
    NSMutableArray *classes;
    NSMutableString *currentString;
    NSMutableDictionary *currentFields;
    NSDateFormatter *dateFormatter;
    
    ScheduleFetcherResultBlock resultBlock;
    NSMutableData *responseData;
    NSURLConnection *connection;
}

    // Returns an NSArray of ScheduledClass objects if successful.
    // Returns nil on failure.
//- (NSArray *)fetchClassesWithError:(NSError **)outError;
- (void)fetchClassesWithBlock:(ScheduleFetcherResultBlock)theBlock;

@end
