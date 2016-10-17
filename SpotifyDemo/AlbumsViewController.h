//
//  AlbumsViewController.h
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface AlbumsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) Artist *artist;
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (strong, nonatomic) UIImage *artistImage;
@end
