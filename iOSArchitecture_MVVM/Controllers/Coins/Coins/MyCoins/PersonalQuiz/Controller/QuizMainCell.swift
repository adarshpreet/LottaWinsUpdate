//
//  QuizMainCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/2/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import UIKit


class QuizMainCell: UICollectionViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var joinCountLabel: UILabel!

    let margin: CGFloat = 20
    var onMessage: SwiftCallBacks.handler?

    var model: QuizListModel? {
        didSet {
            self.setFlowLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNIb()
        // Initialization code
    }
    
     func registerNIb() {
        self.collectionView.registerNIB(QuizCell.className)
        self.collectionView.registerNIB(QuizSecondCell.className)
    }
    
    var items : Int {
        guard let quizModel = self.model else { return 0 }
        return (quizModel.options ?? []).count
    }
    
    func setFlowLayout() {
        
        guard let collectionView = self.collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }

}

extension QuizMainCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.model?.type {
        case "Manual":
        return self.items
        
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCell.className, for: indexPath) as? QuizCell else { return UICollectionViewCell() }
        guard let quizModel = self.model?.options else { return cell }
        
        switch self.model?.type {
        case "Manual":
          //  cell.quizButton.setTitle(quizModel[indexPath.item], for: .normal)
            guard let cellSec = collectionView.dequeueReusableCell(withReuseIdentifier: QuizSecondCell.className, for: indexPath) as? QuizSecondCell else { return UICollectionViewCell() }

                      cellSec.buttonForQuiz.setTitle(quizModel[indexPath.item], for: .normal)
                      cellSec.buttonForQuiz.tag = indexPath.item
                      cellSec.buttonForQuiz.addTarget(self, action: #selector(self.tapOnQuizeButton(_:)), for: .touchUpInside)
                      return cellSec
        case "Thumbs-Up/Thumbs-down":
//            let imageStr = indexPath.item == 0 ? "thumbsUp" : "thumbsDown"
            cell.quizButton.setImage(UIImage(named: "thumbsUp"), for: .normal)
            cell.secondButton.setImage(UIImage(named: "thumbsDown"), for: .normal)

        default:
            cell.quizButton.setTitleColor(AppColor.pinkColor, for: .normal)
            cell.secondButton.setTitleColor(AppColor.newBlueColor, for: .normal)
            cell.quizButton.setTitle(quizModel[0], for: .normal)
            cell.secondButton.setTitle(quizModel[1], for: .normal)

        }
        cell.quizButton.tag = 0
        cell.quizButton.addTarget(self, action: #selector(self.tapOnQuizeButton(_:)), for: .touchUpInside)
        cell.secondButton.tag = 1
        cell.secondButton.addTarget(self, action: #selector(self.tapOnQuizeButton(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func tapOnQuizeButton(_ sender: UIButton) {
        let tag = sender.tag
        sender.backgroundColor = AppColor.ClickYellowColor
        guard let quizOptions = self.model?.options else { return }
        self.onMessage?(quizOptions[tag])
    }
}

extension QuizMainCell : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let quizModel = self.model?.options
        let noOfCellsInRow = self.items <= 3 ? 1 : 2  //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        switch self.model?.type {
        case "Manual":
             return CGSize(width: collectionView.bounds.width, height: 65)
        default:
            return CGSize(width: size, height: 87)

        }
        
    }
}
