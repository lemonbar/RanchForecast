//
//  ScheduledClass.h
//  RanchForecast
//
//  Created by Meng Li on 14-7-18.
//  Copyright (c) 2014年 Meng Li. All rights reserved.
//

#import <Foundation/Foundation.h>
    //Scheuled class model object.
@interface ScheduledClass : NSObject{
    NSString *name;
    NSString *location;
    NSString *href;
    NSDate *begin;
}

@property (nonatomic,copy) NSString *name;
@property (nonatomic, copy)NSString *location;
@property (nonatomic,copy) NSString *href;
@property (nonatomic,strong) NSDate *begin;

@end
