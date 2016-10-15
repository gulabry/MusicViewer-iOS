//
//  Album.h
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import <Foundation/Foundation.h>

@interface Album : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *spotifyUrl;
@property (strong, nonatomic) NSString *spotifyId;
@property (strong, nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) NSString *recordLabel;
@property (strong, nonatomic) NSNumber *popularity;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSNumber *tracks;

+(instancetype)initWithAlbumId:(NSString *)albumId;

+(NSMutableArray *)get:(NSArray *)albumIds withCompletionHandler:(void (^)(NSMutableArray *albums, NSError *error))completionHandler;


@end
