//
//  Artists.h
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import <Foundation/Foundation.h>
#import "Artist.h"

@interface Artists : NSObject

@property (strong, nonatomic) Artist *drake;

+(instancetype)sharedInstance;

+(void)getRelatedTo:(Artist *)artist completion:(void (^)(NSMutableArray *artists, NSError *error))completionHandler;

+(void)get:(NSArray *)artistIds completion:(void (^)(NSMutableArray *artists, NSError *error))completionHandler;

@end
