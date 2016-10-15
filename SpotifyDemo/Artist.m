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
#import "Album.h"

@implementation Artist

-(instancetype)initWithId:(NSString *)artistSpotifyId {
    
    if (self = [super init]) {
        
        Artist *newArtist = [[Artist alloc] init];
        newArtist.spotifyId = artistSpotifyId;
        
        return newArtist;
        
    } else {
        return nil;
    }
}

-(void)getAlbumsWithCompletionHandler:(void (^)(NSMutableArray *albums, NSError *error))completionHandler
{
    NSString *getAlbumUrl = [NSString stringWithFormat:@"%@%@%@%@",baseEndpoint, @"artists/", self.spotifyId, @"/albums"];
    
    NSURL* URL = [NSURL URLWithString:getAlbumUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask* task = [[Network sharedInstance].session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *convertError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&convertError];
        
        if (completionHandler == nil) return;
        
        if (error) {
            completionHandler(nil, error);
            return;
        } else if (convertError) {
            completionHandler(nil, convertError);
        }
        
        NSMutableArray *albums = [Artist marshallAlbumsFromDictionary:json];
        
        completionHandler(albums, nil);
    }];
    [task resume];
    [[Network sharedInstance].session finishTasksAndInvalidate];
}

+(NSMutableArray *)marshallAlbumsFromDictionary:(NSDictionary *)dict {
    NSMutableArray *albums = [NSMutableArray new];
    for (id o in dict[@"items"]) {
        Album *a = [Album new];
        a.name = o[@"name"];
        a.spotifyId = o[@"id"];
        a.spotifyUrl = o[@"external_urls"][@"spotify"];
        
        NSMutableArray *urls = [NSMutableArray new];
        for (id i in o[@"images"]) { //get image urls
            [urls addObject:i[@"url"]];
        }
        
        a.imageUrls = urls;
        [albums addObject:a];
    }
    return albums;
}

@end
