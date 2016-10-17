//
//  Network.h
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

//  Global Session
@property (strong, nonatomic) NSURLSession *session;

+(instancetype)sharedInstance;

+(void)cancelCurrentTasks;

@end
