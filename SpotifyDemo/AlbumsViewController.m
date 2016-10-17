//
//  AlbumsViewController.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import "AlbumsViewController.h"
#import "AlbumCollectionViewCell.h"
#import "Album.h"

@interface AlbumsViewController ()

@property (strong, nonatomic) NSArray *albums;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinning;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [[[Artist alloc] initWithId:@"1Xyo4u8uXC1ZmMpatF05PJ"] getAlbumsWithCompletionHandler:^(NSMutableArray *albums, NSError *error) {
        NSLog(@"%@", albums.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albums = albums;
            [self.collectionView reloadData];
            [self.loadingSpinning stopAnimating];
        });
    }];
}

-(void)setupNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

#pragma mark - UICollectionView Delegate & Data Source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.section * 2 + indexPath.row + 1;
    
    if (index < self.albums.count) {
        
        Album *artist = self.albums[index];
//        cell.nameLabel.text = artist.name;
//        cell.genreLabel.text = [NSString stringWithFormat:@"%@", [artist.genres[0] capitalizedString]];
//        NSString *shortenedFollowers = (artist.followers.intValue >= 1000000) ? [NSString stringWithFormat:@"%dM Followers", artist.followers.intValue / 1000000] : [NSString stringWithFormat:@"%@ Followers", artist.followers];
//        cell.followersLabel.text = shortenedFollowers;
//        cell.albumImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:artist.imageUrls[0]] placeholderImage:[UIImage imageNamed:@"note"]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
