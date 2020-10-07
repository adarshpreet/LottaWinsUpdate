//
//  PersonalityQuizOneVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 19/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit



class PersonalityQuizVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var onMessage: SwiftCallBacks.handler?

    lazy var viewModel: PersonQuizModel = {
       let obj = PersonQuizModel(userService: UserService())
       self.baseVwModel = obj
       return obj
    }()

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
}

extension PersonalityQuizVC : BaseDataSources {
    
    func setUpClosures() {
        self.viewModel.redirectClosure = { [weak self] type in
            guard let self = `self` else { return }
            
            if type == "movetoNext" {
                guard let indexPath = self.collectionView.centerCellIndexPath else { return }
                if indexPath.item < self.viewModel.items - 1 {
                    let nextIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
                    self.collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                } else {
                    guard let model = self.viewModel.giveAwayDetail else { return }
                    self.onMessage?(model)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func setUpView() {
        //self.setFlowLayout()
        
        self.setUpClosures()
        self.setLayouts()
    }
    
    func setLayouts() {
        let screenSize = UIScreen.main.bounds
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenSize.width, height: self.collectionView.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = . vertical
        self.collectionView.collectionViewLayout = layout
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension PersonalityQuizVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizMainCell.className, for: indexPath) as? QuizMainCell else { return UICollectionViewCell() }
        guard let model = self.viewModel.quizModel?[indexPath.item] else { return cell }
        cell.titleLabel.text = model.title
        cell.countLabel.text = "\(indexPath.item + 1)" + "/" + "\(self.viewModel.items)"
        cell.model = model
//        cell.backgroundImage.sd_setImage(with: URL(string: model.image ?? ""), placeholderImage: UIImage(named: "Welcome_logo"), options: .continueInBackground, context: nil)
        cell.joinCountLabel.text = "\(self.viewModel.singleGiveAway?.user_count ?? 0)"

        cell.onMessage = { [weak self] snapShot in
            guard let self = `self` else { return }

            if let answer = snapShot as? String {
                self.viewModel.increaseSponsoredCoins(content: model, selectedAnswer: answer)
            }
        }
        return cell
    }
}

extension PersonalityQuizVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}



