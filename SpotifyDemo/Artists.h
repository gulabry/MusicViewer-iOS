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

@property (strong, nonatomic) NSArray *related;
@property (strong, nonatomic) NSArray *all;

@property (strong, nonatomic) Artist *drake;

+(instancetype)sharedInstance;

-(void)relatedTo:(Artist *)artist;
-(NSArray *)get:(NSArray *)artistIds;

@end
