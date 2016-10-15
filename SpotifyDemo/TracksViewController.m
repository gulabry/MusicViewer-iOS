//
//  TracksViewController.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import "TracksViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TracksViewController ()

@property (strong, nonatomic) AVPlayer *audioPlayer;

@end

@implementation TracksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.audioPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"https://p.scdn.co/mp3-preview/148e345380fd889f4b0ac87147822edafda00bba"]];
        [self.audioPlayer play];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
