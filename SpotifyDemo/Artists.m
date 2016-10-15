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
        artists.drake = [[Artist alloc] initWithId:@"3TVXtAsR1Inumwj472S9r4"];
    });
    return artists;
}

+(void)getRelatedTo:(Artist *)artist completion:(void (^)(NSMutableArray *artists, NSError *error))completionHandler
{
    NSString *drakeUrl = [NSString stringWithFormat:@"%@%@%@%@",baseEndpoint, @"artists/", [Artists sharedInstance].drake.spotifyId, @"/related-artists"];
    
    NSURL* URL = [NSURL URLWithString:drakeUrl];
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
        
        NSMutableArray *relatedArtists = [Artists marshallArtistsFromDictionary:json];
        
        completionHandler(relatedArtists, nil);
    }];
    [task resume];
    [[Network sharedInstance].session finishTasksAndInvalidate];
}

+(void)get:(NSArray *)artistIds completion:(void (^)(NSMutableArray *artists, NSError *error))completionHandler {
    
    if (artistIds.count >= 50) {
        NSLog(@"You must lookup fewer than 50 artists");
        NSString *domain = @"com.GulaBryan";
        NSString *desc = NSLocalizedString(@"Lookup Error ", @"Search Less than 50 artists");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
        
        NSError *error = [NSError errorWithDomain:domain
                                             code:-101
                                         userInfo:userInfo];
        completionHandler(nil, error);
        return;
    }
    
    NSMutableString *stringOfIds = [self combineArrayIntoCommaSeperatedString:artistIds];
    NSString *getArtistsUrl = [NSString stringWithFormat:@"%@%@%@",baseEndpoint, @"artists?ids=", stringOfIds];
    
    NSURL* URL = [NSURL URLWithString:getArtistsUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask* task = [[Network sharedInstance].session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *convertError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&convertError];
        
        if (completionHandler == nil) return;
        
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        NSMutableArray *artists = [Artists marshallArtistsFromDictionary:json];
        
        completionHandler(artists, nil);
    }];
    [task resume];
    [[Network sharedInstance].session finishTasksAndInvalidate];
}

+(NSMutableString *)combineArrayIntoCommaSeperatedString:(NSArray *)array {
    NSMutableString *stringOfIds = [array[0] mutableCopy];
    NSMutableArray *mutableIds = [array mutableCopy];
    [mutableIds removeObjectAtIndex:0]; //remove first object to remove fencepost problem
    
    for (NSString *s in mutableIds) {
        [stringOfIds appendString:@","];
        [stringOfIds appendString:s];
    }
    return stringOfIds;
}

+(NSMutableArray *)marshallArtistsFromDictionary:(NSDictionary *)dict {
    NSMutableArray *relatedArtists = [NSMutableArray new];
    for (id o in dict[@"artists"]) {
        Artist *a = [Artist new];
        a.name = o[@"name"];
        a.popularity = o[@"popularity"];
        a.followers = o[@"followers"][@"total"];
        a.spotifyId = o[@"id"];
        a.uri = o[@"external_urls"][@"spotify"];
        
        NSMutableArray *urls = [NSMutableArray new];
        for (id i in o[@"images"]) { //get image urls
            [urls addObject:i[@"url"]];
        }
        
        a.imageUrls = urls;
        a.genres = o[@"genres"];
        [relatedArtists addObject:a];
    }
    return relatedArtists;
}

@end
