//
//  AlbumsViewController.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AlbumsViewController.h"
#import "AlbumCollectionViewCell.h"
#import "Album.h"

@interface AlbumsViewController ()

@property (strong, nonatomic) NSArray *albums;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinning;
@property (weak, nonatomic) IBOutlet UILabel *latestAlbumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAlbumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UIButton *showSpotifyProfileButton;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self setupView];
    
    [self.artist getAlbumsWithCompletionHandler:^(NSMutableArray *albums, NSError *error) {
        NSLog(@"%@", albums.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albums = albums;
            [self.collectionView reloadData];
            [self.loadingSpinning stopAnimating];
            [self setupViewAfterAlbumsLoaded];
        });
    }];
}

-(void)setupView {
    self.artistLabel.text = self.artist.name;
    self.genreLabel.text = [[self.artist.genres componentsJoinedByString:@", " ] capitalizedString];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
    self.followersLabel.text = [[fmt stringFromNumber:self.artist.followers] stringByAppendingString:@" Followers"];
}

-(void)setupViewAfterAlbumsLoaded {
    self.latestAlbumLabel.text = [[@"Latest: " stringByAppendingString:((Album*)self.albums[0]).name] capitalizedString];
    self.totalAlbumsLabel.text = [NSString stringWithFormat:@"%zd Albums", self.albums.count];
}

-(void)setupNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIImage *arrow = [UIImage imageNamed:@"arrow_left"];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.bounds = CGRectMake(0, 0, arrow.size.width / 2.5, arrow.size.height / 2.5);
    back.tintColor = [UIColor whiteColor];
    back.contentMode = UIViewContentModeScaleAspectFit;
    back.contentEdgeInsets = UIEdgeInsetsMake(-5, -10, 5, 10);
    [back addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:arrow forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UICollectionView Delegate & Data Source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.section * 2 + indexPath.row + 1;
    
    if (index < self.albums.count) {
        
        Album *album = self.albums[index];
        cell.titleLabel.text = album.name;
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy";
        if (album.isExplicit) {
            cell.detailsLabel.hidden = false;
        }
        cell.detailsLabel.text = [formatter stringFromDate: album.releaseDate];
        cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:((Album*)self.albums[index]).imageUrls[0]] placeholderImage:[UIImage imageNamed:@"note"]];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.albums.count / 2;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.darkenView.alpha = 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.darkenView.alpha = 1.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width / 2 - 10, 200);
}

#pragma mark - UITableView Delegate & Data Source

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//}

#pragma mark - Navigation

- (IBAction)showSpotifyProfile:(id)sender {
    
}

-(void)dismissSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
