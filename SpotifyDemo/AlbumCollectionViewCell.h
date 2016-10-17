//
//  AlbumCollectionViewCell.h
//  SpotifyDemo
//
//  Created by CardSwapper on 10/16/16.
//
//

#import <UIKit/UIKit.h>

@interface AlbumCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *darkenView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImageView;
@end
