//
//  WBPhotoTimelineSectionHeaderButton.m
//  whiteboard
//
//  Created by prs-fueled on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoTimelineSectionHeaderButton.h"

@interface WBPhotoTimelineSectionHeaderButton()
@property (nonatomic, strong) UIButton *button;
@end

@implementation WBPhotoTimelineSectionHeaderButton

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setupView];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self){
    [self setupView];
  }
  return self;
}

#pragma mark - Setup
- (void)setupView {
  // Add the button
  [self addSubview:self.button];
  
  // Add number label
  [self addSubview:self.numberLabel];
  
  // Defaults
  self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Accessors
- (UIButton *)button {
  if(_button != nil){
    return _button;
  }
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button addTarget:self
             action:@selector(buttonPressed)
   forControlEvents:UIControlEventTouchUpInside];
  
  _button = button;
  return _button;
}

- (UILabel *)numberLabel {
  if(_numberLabel != nil){
    return _numberLabel;
  }
  
  UILabel *label = [[UILabel alloc] init];
  label.backgroundColor = [UIColor clearColor];
  label.textAlignment = NSTextAlignmentCenter;
  
  _numberLabel = label;
  return _numberLabel;
}

#pragma mark - Setters
- (void)setNormalImage:(UIImage *)normalImage {
  _normalImage = normalImage;
  
  [self.button setImage:self.normalImage forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
  _highlightedImage = highlightedImage;
  
  [self.button setImage:self.highlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
  _selectedImage = selectedImage;
  
  [self.button setImage:self.selectedImage forState:UIControlStateSelected];
}

#pragma mark - Layout
- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Button frame
  CGRect buttonFrame = CGRectMake(0.f,
                                  0.f,
                                  self.frame.size.width,
                                  self.frame.size.height);
  self.button.frame = buttonFrame;
  
  // Number frame
  CGRect numberFrame = CGRectMake(0.f,
                                  0.f,
                                  self.frame.size.width,
                                  self.frame.size.height);
  self.numberLabel.frame = numberFrame;
}

#pragma mark - Actions
- (void)buttonPressed {
  if([self.delegate respondsToSelector:@selector(wbPhotoTimelineSectionHeaderButtonPressed:)]){
    [self.delegate wbPhotoTimelineSectionHeaderButtonPressed:self];
  }
}

@end
