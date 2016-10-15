//
//  Artists.m
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import "Artists.h"
#import "Network.h"
#import "Constants.h"

@implementation Artists

+(instancetype)sharedInstance {
    
    static Artists *artists = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        artists = [[Artists alloc] init];
        artists.drake = [[Artist alloc] initWithId:@""];
        
    });
    return artists;
}

-(void)relatedTo:(Artist *)artist
{
    NSURL* URL = [NSURL URLWithString:relatedArtistsEndpoint];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask* task = [[Network sharedInstance].session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
    [[Network sharedInstance].session finishTasksAndInvalidate];
}

-(NSArray *)get:(NSArray *)artistIds {
    return @[];
}

@end
