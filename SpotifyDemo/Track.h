//
//  Track.h
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (nonatomic) BOOL isExplicit;
@property (strong, nonatomic) NSString *spotifyId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *popularity;
@property (strong, nonatomic) NSString *previewUrl;
@property (strong, nonatomic) NSNumber *durition;

@end
