//
//  URLRequestExtensions.m
//  Vienna
//
//  Created by Barijaona Ramaholimihaso on 03/08/2018.
//  Copyright © 2018 uk.co.opencommunity. All rights reserved.
//

#import "URLRequestExtensions.h"

// we extend the capabilities of NSMutableURLRequest and store and retrieve specific request data
// by using NSURLProtocol’s class methods propertyForKey:inRequest: and setProperty:forKey:inRequest:
@implementation NSMutableURLRequest (userDict)

-(id)userInfo
{
    return [NSURLProtocol propertyForKey:NSStringFromSelector(@selector(userInfo)) inRequest:self];
}

-(void)setUserInfo:(id)userDict
{
    [NSURLProtocol setProperty:userDict forKey:NSStringFromSelector(@selector(userInfo)) inRequest:self];
}

-(void)setInUserInfo:(id)object forKey:(NSString *)key
{
    NSMutableDictionary *workingDict =
        [((NSDictionary *)[NSURLProtocol propertyForKey:NSStringFromSelector(@selector(userInfo)) inRequest:self]) mutableCopy];
    if (workingDict == nil) {
        workingDict = [[NSMutableDictionary alloc] init];
    }

    [workingDict setObject:object forKeyedSubscript:key];
    [NSURLProtocol setProperty:[NSDictionary dictionaryWithDictionary:workingDict] forKey:NSStringFromSelector(@selector(userInfo))
                     inRequest:self];
}

@end

// create or extend HTTP body (for "application/x-www-form-urlencoded" content type)
@implementation NSMutableURLRequest (MutablePostExtensions)

-(void)setPostValue:(NSString *)value forKey:(NSString *)key
{
    NSMutableData *data1;
    NSData *data2;
    NSString *stringData;

    data1 = [NSMutableData dataWithData:self.HTTPBody];
    if (data1.length > 0) {
        stringData = [NSString stringWithFormat:@"&%@=%@", key, value];
    } else {
        stringData = [NSString stringWithFormat:@"%@=%@", key, value];
    }
    data2 = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    [data1 appendData:data2];
    self.HTTPBody = data1;
    [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
}

@end