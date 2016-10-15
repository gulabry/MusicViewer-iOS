//
//  Network.m
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import "Network.h"
#import "Constants.h"

@implementation Network

+(instancetype)sharedInstance {
    
    static Network *network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[Network alloc] init];
        network.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return network;
}

-(void)sendRequest:(id)sender
{
    NSURL* URL = [NSURL URLWithString:relatedArtistsEndpoint];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
    [self.session finishTasksAndInvalidate];
}

@end
