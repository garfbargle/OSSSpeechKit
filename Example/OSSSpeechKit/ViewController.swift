//
//  ViewController.swift
//  OSSSpeechKit
//
//  Created by appdevguy on 06/06/2019.
//  Copyright (c) 2019 appdevguy. All rights reserved.
//

import UIKit
import PureLayout
import OSSSpeechKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    
    private var hasSetConstraints: Bool = false
    private let speechKit = OSSSpeech.shared
    
    // MARK: - View Elements
    
    lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        // Register cell classes
        cv.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: BasicCollectionViewCell.reuseIdentifier)
        return cv
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(collectionView)
        self.view.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViewConstraints()
    }

    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !hasSetConstraints {
            hasSetConstraints = true
            collectionView.autoPinEdgesToSuperviewSafeArea()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = OSSVoiceEnum.allCases.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCollectionViewCell.reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
        cell.backgroundColor = .white
        cell.titleLabel.text = OSSVoiceEnum.allCases[indexPath.item].title
        cell.subtitleLabel.text = OSSVoiceEnum.allCases[indexPath.item].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // NOTE: Must set the voice before requesting speech. This can be set once.
        speechKit.voice = OSSVoice(quality: .enhanced, language: OSSVoiceEnum.allCases[indexPath.item])
        self.speechKit.speakText(text: OSSVoiceEnum.allCases[indexPath.item].demoMessage)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.setNeedsUpdateConstraints()
    }
    
    //Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}


extension UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}