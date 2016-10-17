//
//  AlbumsViewController.h
//  SpotifyDemo
//
//  Created by Bryan Gula on 10/15/16.
//
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface AlbumsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
//UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Artist *artist;

@end
