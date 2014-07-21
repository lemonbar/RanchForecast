//
//  ScheduleFetcher.m
//  RanchForecast
//
//  Created by Meng Li on 14-7-18.
//  Copyright (c) 2014年 Meng Li. All rights reserved.
//

#import "ScheduleFetcher.h"
#import "ScheduledClass.h"

@implementation ScheduleFetcher
- (id)init
{
    self = [super init];
    if (self) {
        classes = [[NSMutableArray alloc] init];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

- (void)fetchClassesWithBlock:
(ScheduleFetcherResultBlock)theBlock
{
    // Copy the block to ensure that it is not kept on the stack:
    resultBlock = [theBlock copy];
    NSURL *url =[NSURL URLWithString:@"http://bignerdranch.com"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url
                                         cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                     timeoutInterval:30];
    connection = [[NSURLConnection alloc]
                  initWithRequest:req
                  delegate:self];
    if (connection)
        {
        responseData = [[NSMutableData alloc] init];
        }
}

- (void)cleanup
{
    responseData = nil;
    connection = nil;
    resultBlock = nil;
}

//- (NSArray *)fetchClassesWithError:(NSError **)outError
//{
//    BOOL success;
//    NSURL *url =[NSURL URLWithString:@"http://bignerdranch.com/classes"];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url
//                                         cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                     timeoutInterval:30];
//    NSURLResponse *resp = nil;
//    
////    [NSURLConnection
////                    sendSynchronousRequest:req
////                    returningResponse:&resp
////                    error:outError];
//    NSString *filePath = @"/Users/limeng0402/Documents/ObjectC/Hello Objective-C/RanchForecast/RanchForecast/test.xml";
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    if (!data)
//        return nil;
//    [classes removeAllObjects];
//    NSXMLParser *parser;
//    parser = [[NSXMLParser alloc] initWithData:data];
//    [parser setDelegate:self];
//    success = [parser parse];
//    if (!success)
//        {
//        *outError = [parser parserError];
//        return nil;
//        }
//    NSArray *output = [classes copy];
//    return output;
//}

#pragma mark -
#pragma mark NSXMLParserDelegate Methods
    //parser when the element start.
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"class"])
        {
        currentFields = [[NSMutableDictionary alloc]
                         init];
        }
}
    //parser when the element end.
- (void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"class"])
        {
        ScheduledClass *currentClass = [[ScheduledClass
                                         alloc] init];
        [currentClass setName:[currentFields
                               objectForKey:@"offering"]];
        [currentClass setLocation:[currentFields
                                   objectForKey:@"location"]];
        [currentClass setHref:[currentFields
                               objectForKey:@"href"]];
        NSString *beginString = [currentFields
                                 objectForKey:@"begin"];
        NSDate *beginDate = [dateFormatter
                             dateFromString:beginString];
        [currentClass setBegin:beginDate];
        [classes addObject:currentClass];
        currentClass = nil;
        currentFields = nil;
        }
    else if (currentFields && currentString)
        {
        NSString *trimmed;
        trimmed = [currentString
                   stringByTrimmingCharactersInSet:
                   [NSCharacterSet
                    whitespaceAndNewlineCharacterSet]];
        [currentFields setObject:trimmed
                          forKey:elementName];
        }
    currentString = nil;
}
    //found characters except the element includes <>.
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    if (!currentString) {
        currentString = [[NSMutableString alloc] init];
    }
    [currentString appendString:string];
}

#pragma mark -
#pragma mark NSURLConnection Delegate
- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)data
{
    NSString *filePath = @"/Users/limeng0402/Documents/ObjectC/Hello Objective-C/RanchForecast/RanchForecast/test.xml";
    NSData *dataNew = [NSData dataWithContentsOfFile:filePath];

    [responseData appendData:dataNew];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)
theConnection
{
    [classes removeAllObjects];
    NSXMLParser *parser = [[NSXMLParser alloc]
                           initWithData:responseData];
    [parser setDelegate:self];
    BOOL success = [parser parse];
    if (!success)
        {
        resultBlock(nil, [parser parserError]);
        }
    else
        {
        NSArray *output = [classes copy];
        resultBlock(output, nil);
        }
    [self cleanup];
}
- (void)connection:(NSURLConnection *)theConnection
  didFailWithError:(NSError *)error
{
    resultBlock(nil, error);
    [self cleanup];
}

@end
