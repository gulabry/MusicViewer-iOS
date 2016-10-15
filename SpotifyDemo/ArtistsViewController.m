//
//  ArtistsViewController.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import <AVFoundation/AVFoundation.h>
#import "ArtistsViewController.h"
#import "Artists.h"
#import "Network.h"
#import "Album.h"

@interface ArtistsViewController ()

@property (strong, nonatomic) NSArray *artists;

@end

@implementation ArtistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [Artists getRelatedTo:[Artists sharedInstance].drake completion:^(NSMutableArray *artists, NSError *error) {
        NSLog(@"%@", artists.description);
        self.artists = artists;
        //[self.collectionView reloadData]
    }];

//    [Artists get:@[@"1Xyo4u8uXC1ZmMpatF05PJ", @"2YZyLoL8N0Wb9xBt1NhZWg", @"1RyvyyTE3xzB2ZywiAwp0i"] completion:^(NSMutableArray *artists, NSError *error) {
//            NSLog(@"%@", artists.description);
//    }];


//    [[[Artist alloc] initWithId:@"1Xyo4u8uXC1ZmMpatF05PJ"] getAlbumsWithCompletionHandler:^(NSMutableArray *albums, NSError *error) {
//        NSLog(@"%@", albums.description);
//    }];
    
//    [Album get:@[@"36yJ6fcaSCVsK1tybnNizj"] withCompletionHandler:^(NSMutableArray *albums, NSError *error) {
//        NSLog(@"%@", albums.description);
//    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
