//
//  Artist.h
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject

@property (strong, nonatomic) NSString *uri;
@property (strong, nonatomic) NSNumber *followers;
@property (strong, nonatomic) NSArray *genres;
@property (strong, nonatomic) NSString *spotifyId;
@property (strong, nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *popularity;
@property (strong, nonatomic) NSArray *albums;
@property (strong, nonatomic) NSNumber *totalAlbums;

-(instancetype)initWithId:(NSString *)artistSpotifyId;

-(void)getAlbumsWithCompletionHandler:(void (^)(NSMutableArray *albums, NSError *error))completionHandler;

@end
