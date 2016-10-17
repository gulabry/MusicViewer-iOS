//
//  ArtistsViewController.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AlbumsViewController.h"
#import "ArtistsViewController.h"
#import "Artists.h"
#import "Network.h"
#import "Album.h"
#import "ArtistCollectionViewCell.h"

@interface ArtistsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *artists;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end

@implementation ArtistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [Artists getRelatedTo:[Artists sharedInstance].drake completion:^(NSMutableArray *artists, NSError *error) {
        NSLog(@"%@", artists.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.artists = artists;
            [self.collectionView reloadData];
            [self.loadingSpinner stopAnimating];
        });
    }];

//    [[[Artist alloc] initWithId:@"1Xyo4u8uXC1ZmMpatF05PJ"] getAlbumsWithCompletionHandler:^(NSMutableArray *albums, NSError *error) {
//        NSLog(@"%@", albums.description);
//    }];
    
//    [Album get:@[@"36yJ6fcaSCVsK1tybnNizj"] withCompletionHandler:^(NSMutableArray *albums, NSError *error) {
//        NSLog(@"%@", albums.description);
//    }];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [Network cancelCurrentTasks];
}

#pragma mark - CollectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArtistCollectionViewCell *cell = (ArtistCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"artistCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.section * 2 + indexPath.row + 1;
    
    if (index < self.artists.count) {
        
        Artist *artist = self.artists[index];
        cell.nameLabel.text = artist.name;
        cell.genreLabel.text = [NSString stringWithFormat:@"%@", [artist.genres[0] capitalizedString]];
        NSString *shortenedFollowers = (artist.followers.intValue >= 1000000) ? [NSString stringWithFormat:@"%dM Followers", artist.followers.intValue / 1000000] : [NSString stringWithFormat:@"%@ Followers", artist.followers];
        cell.followersLabel.text = shortenedFollowers;
        cell.albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:artist.imageUrls[0]] placeholderImage:[UIImage imageNamed:@"note"]];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.artists.count / 2;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width / 2 - 10, 200);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAlbums"]) {
        AlbumsViewController *vc = [segue destinationViewController];
        ArtistCollectionViewCell *cell = (ArtistCollectionViewCell*)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSInteger index = indexPath.section * 2 + indexPath.row + 1;
        vc.artist = self.artists[index];
        vc.artistImage = cell.albumImageView.image;
    }
}

#pragma mark - Helper Functions



@end
