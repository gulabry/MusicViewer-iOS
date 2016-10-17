//
//  AlbumsViewController.m
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "SVModalWebViewController.h"
#import "Network.h"
#import "AlbumsViewController.h"
#import "AlbumCollectionViewCell.h"
#import "TrackTableViewCell.h"
#import "Track.h"
#import "Album.h"

@interface AlbumsViewController ()

@property (strong, nonatomic) NSArray *albums;
@property (strong, nonatomic) Album *selectedAlbum;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinning;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinnerForViewController;
@property (weak, nonatomic) IBOutlet UILabel *totalAlbumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UIButton *showSpotifyProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *closeAlbumViewButton;
@property (weak, nonatomic) IBOutlet UILabel *closeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *albumVisualEffectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomConstraint;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    NSMutableArray *mutableGenres= [self.artist.genres mutableCopy];
    
    //  more than 4 genre labels is too much for the screen
    if (mutableGenres.count - 1 > 5) {
        [mutableGenres removeObjectsInRange:NSMakeRange(4, mutableGenres.count - 1)];
    }
    
    self.genreLabel.text = [[mutableGenres componentsJoinedByString:@", " ] capitalizedString];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
    self.followersLabel.text = [[fmt stringFromNumber:self.artist.followers] stringByAppendingString:@" Followers"];
    
    self.tableView.hidden = YES;
    self.tableView.alpha = 0.0; //Hidden until user selects album
    self.albumImageView.hidden = YES;
    self.albumImageView.alpha = 0.0;
    self.albumVisualEffectView.hidden = YES;
    self.albumVisualEffectView.alpha = 0.0;
    self.artistImageView.image = self.artistImage;
    self.closeAlbumViewButton.hidden = YES;
    self.closeAlbumViewButton.alpha = 0.0;
    self.closeLabel.hidden = YES;
    self.closeLabel.alpha = 0.0;
}

-(void)setupViewAfterAlbumsLoaded {
    self.totalAlbumsLabel.text = [NSString stringWithFormat:@"%zd+ Albums", self.albums.count];
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

-(void)prepareTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        self.albumImageView.hidden = NO;
        self.albumVisualEffectView.hidden = NO;
        self.closeAlbumViewButton.hidden = NO;
        self.closeLabel.hidden = NO;
        self.closeAlbumViewButton.layer.cornerRadius = self.closeAlbumViewButton.frame.size.width / 2;
        self.closeAlbumViewButton.backgroundColor = [UIColor whiteColor];
        self.closeAlbumViewButton.layer.masksToBounds = YES;
        [self.loadingSpinnerForViewController stopAnimating];
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.alpha = 1.0;
            self.albumImageView.alpha = 1.0;
            self.albumVisualEffectView.alpha = 1.0;
            self.closeAlbumViewButton.alpha = 1.0;
            self.closeLabel.alpha = 1.0;
        }];
    });
}

-(void)hideTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.alpha = 0.0;
            self.albumImageView.alpha = 0.0;
            self.albumVisualEffectView.alpha = 0.0;
            self.closeAlbumViewButton.alpha = 0.0;
            self.closeLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.tableView.hidden = YES;
            self.albumImageView.hidden = YES;
            self.albumVisualEffectView.hidden = YES;
            self.closeAlbumViewButton.hidden = YES;
            self.closeLabel.hidden = YES;
        }];
    });
}

-(void)viewWillDisappear:(BOOL)animated {
    [Network cancelCurrentTasks];
}

#pragma mark - UICollectionView Delegate & Data Source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.section * 2 + indexPath.row + 1;
    
    if (index < self.albums.count) {
        
        Album *album = self.albums[index];
        cell.titleLabel.text = album.name;
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
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self moveCollectionViewToShowAlbumTracks];
    
    NSInteger index = indexPath.section * 2 + indexPath.row + 1;
    Album *selectedAlbum = self.albums[index];
    [Album get:@[selectedAlbum.spotifyId] withCompletionHandler:^(NSMutableArray *albums, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedAlbum = albums[0];
            self.albumImageView.image = cell.albumArtImageView.image;
            [self.loadingSpinnerForViewController startAnimating];
            [self prepareTableView];
        });
    }];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackCell"];
    Track *track = self.selectedAlbum.tracks[indexPath.row];
    
    cell.titleLabel.text = track.name;
    cell.durationLabel.text = [self getTimeStringFromSeconds:[track.durition doubleValue] / 1000.0];
    if (track.isExplicit) {
        cell.explicitLabel.layer.cornerRadius = cell.explicitLabel.frame.size.width / 2;
        cell.explicitLabel.backgroundColor = [UIColor darkGrayColor];
        cell.explicitLabel.layer.masksToBounds = YES;
        cell.explicitLabel.hidden = NO;
    } else {
        cell.explicitLabel.hidden = YES;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedAlbum.tracks.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Animation

-(void)moveCollectionViewToShowAlbumTracks {
    CGFloat height = self.collectionView.frame.size.height;
    self.collectionViewTopConstraint.constant = 110 + height;
    self.collectionViewBottomConstraint.constant = -height;

    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)moveBackToAlbumView {
    self.collectionViewTopConstraint.constant = 110;
    self.collectionViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)closeAlbumView:(id)sender {
    [self hideTableView];
    [self moveBackToAlbumView];
}

#pragma mark - Navigation

- (IBAction)showSpotifyProfile:(id)sender {
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:self.artist.uri];
    [self presentViewController:webViewController animated:YES completion:NULL];
}

-(void)dismissSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark - Helpers

-(NSString *)getTimeStringFromSeconds:(double)seconds
{
    NSDateComponentsFormatter *dcFormatter = [[NSDateComponentsFormatter alloc] init];
    dcFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dcFormatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute;
    dcFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    return [dcFormatter stringFromTimeInterval:seconds];
}


@end
