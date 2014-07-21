//
//  ScheduledClass.m
//  RanchForecast
//
//  Created by Meng Li on 14-7-18.
//  Copyright (c) 2014年 Meng Li. All rights reserved.
//

#import "ScheduledClass.h"

@implementation ScheduledClass

@synthesize name,location,href,begin;

- (NSString *)description
{
    NSDateFormatter *df = [[NSDateFormatter alloc]
                           init];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterMediumStyle];
    NSString *result;
    result = [[NSString alloc] initWithFormat:@"name=%@, location=%@, href=%@, begin=%@",
              name,location,href,[df stringFromDate:begin]];
    return result;
}

@end
