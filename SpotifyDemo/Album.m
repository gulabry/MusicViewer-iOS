//
//  Album.m
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import "Album.h"
#import "Network.h"
#import "Artist.h"
#import "Constants.h"
#import "Track.h"

@implementation Album

-(instancetype)initWithAlbumId:(NSString *)albumId {
    if (self = [super init]) {
        
        Album *newAlbum = [[Album alloc] init];
        newAlbum.spotifyId = albumId;
        
        return newAlbum;
        
    } else {
        return nil;
    }
}

+(void)get:(NSArray *)albumIds withCompletionHandler:(void (^)(NSMutableArray *albums, NSError *error))completionHandler {
    
    NSMutableString *albumsUrl = [self combineArrayIntoCommaSeperatedString:albumIds];
    
    NSString *getAlbumsUrl = [NSString stringWithFormat:@"%@%@%@",baseEndpoint, @"albums?ids=", albumsUrl];
    
    NSURL* URL = [NSURL URLWithString:getAlbumsUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask* task = [[Network sharedInstance].session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *convertError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&convertError];
        
        if (completionHandler == nil) return;
        
        if (error || data == nil) {
            completionHandler(nil, error);
            return;
        } else if (convertError) {
            completionHandler(nil, convertError);
        }
        
        NSMutableArray *albums = [Album marshallAlbumInfoFromDictionary:json];
        
        completionHandler(albums, nil);
    }];
    [task resume];
}

+(NSMutableArray *)marshallAlbumInfoFromDictionary:(NSDictionary *)dict {
    NSMutableArray *albums = [NSMutableArray new];
    for (id o in dict[@"albums"]) {
        Album *a = [Album new];
        a.name = o[@"name"];
        a.recordLabel = o[@"label"];
        a.popularity = o[@"popularity"];
        a.spotifyId = o[@"id"];
        a.spotifyUrl = o[@"external_urls"][@"spotify"];
       
        //  format release date
        NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat:@"yyyy/MM/dd"];
        a.releaseDate = [myFormatter dateFromString:o[@"release_date"]];
        
        NSMutableArray *urls = [NSMutableArray new];
        for (id i in o[@"images"]) { //get image urls
            [urls addObject:i[@"url"]];
        }
        a.imageUrls = urls;
        
        NSMutableArray *tracks = [NSMutableArray new];
        for (id i in o[@"tracks"][@"items"]) { //get Tracks
            Track *t = [Track new];
            t.name = i[@"name"];
            t.spotifyId = i[@"id"];
            t.isExplicit = i[@"explicit"];
            t.number = i[@"track_number"];
            t.previewUrl = i[@"preview_url"];
            t.durition = i[@"duration_ms"];
            
            [tracks addObject:t];
        }
        a.tracks = tracks;
        
        [albums addObject:a];
    }
    return albums;
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


@end
