//
//  Artist.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import "Artist.h"
#import "Network.h"
#import "Constants.h"

@implementation Artist

+(instancetype)initWithId:(NSString *)artistSpotifyId {
    
    Artist *newArtist = [[Artist alloc] init];
    
    
    
    return newArtist;
}

- (void)sendRequest:(id)sender
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



-(instancetype)init {
    self = [super init];
    if (self) {
        _uri = nil;
        _followers = nil;
        _genres = nil;
        _spotifyId = nil;
        _imageUrls = nil;
        _name = nil;
        _popularity = nil;
        _albums = nil;
    }
    return self;
}

@end
