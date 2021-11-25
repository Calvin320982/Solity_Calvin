//
//  SLTMainTableViewCell.swift
//  Solity Demo
//
//  Created by Solity 013 on 2021/11/25.
//

import UIKit

class SLTMainTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configUI() {
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
    }
    
    func refreshUIWithData(_ titles: NSArray, _ images: NSArray, _ indexPath: Int) {
        if titles.count != 0 {
            let titleDictionary: NSDictionary = titles[indexPath] as! NSDictionary
            let titleArray: NSArray = titleDictionary.allKeys as NSArray
            title.text = titleArray.firstObject as? String
            
            let subtitleDictionary: NSDictionary = titles[indexPath] as! NSDictionary
            let subtitleArray: NSArray = subtitleDictionary.allValues as NSArray
            subtitle.text = subtitleArray.firstObject as? String
        }
        if images.count != 0 {
            self.contentView.addSubview(circleView)
            self.contentView.addSubview(iconImage)
            let image = images[indexPath] as! String
            iconImage.image = UIImage(named: image)
        } else {
            title.frame = CGRect(x: 30, y: 21, width: 323 * widthScale, height: 22.5)
            subtitle.frame = CGRect(x: 30, y: 47, width: 323 * widthScale, height: 16.5)
        }
    }
    
    //MARK:Lazy loading
    lazy var title: UILabel = {
        let label = UILabel(frame: CGRect(x: 86, y: 21, width: 270 * widthScale, height: 22.5))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR(0x303030)
        return label
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 86, y: 47, width: 270 * widthScale, height: 16.5))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = COLOR(0x999999)
        return label
    }()
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 30, y: 31, width: 21, height: 21))
        return imageView
    }()
    
    lazy var circleView: UIView = {
        let view = UIView(frame: CGRect(x: 15.5, y: 16.5, width: 53, height: 53))
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = 26
        view.layer.borderColor = COLOR(0x3486FF).cgColor
        return view
    }()
}
