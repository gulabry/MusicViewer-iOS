//
//  Network.m
//  SpotifyDemo
//
//  Created by CardSwapper on 10/15/16.
//
//

#import "Network.h"
#import "Constants.h"

@implementation Network

+(instancetype)sharedInstance {
    
    static Network *network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[Network alloc] init];
        network.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return network;
}

@end
