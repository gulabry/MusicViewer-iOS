//
//  AlbumsViewController.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import "AlbumsViewController.h"
#import "Album.h"

@interface AlbumsViewController ()

@property (strong, nonatomic) NSArray *albums;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];

}

-(void)setupNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
