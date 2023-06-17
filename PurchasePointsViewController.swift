//
//  PurchasePointsViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 11/25/22.
//

import UIKit
import FirebaseAuth

class PurchasePointsViewController: UIViewController {

    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userPointsLabel: UILabel!
    @IBOutlet weak var tierSixView: UIView!
    @IBOutlet weak var tierFiveView: UIView!
    @IBOutlet weak var tierFourView: UIView!
    @IBOutlet weak var tierThreeView: UIView!
    @IBOutlet weak var tierTwoView: UIView!
    
    @IBOutlet weak var tierOneView: UIView!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
            self.userPointsLabel.text = "\(user?.points ?? 0)"
        }
        view.overrideUserInterfaceStyle = .light
        self.setupView1()
        self.setupView2()
        // Do any additional setup after loading the view.
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(selectView))
//        tierOneView.addGestureRecognizer(tap)
    }
    
    var tierOne = UIView()
    
    var tierThree = UIView()
    
    var tierThreePriceLabel = UILabel()
    
    var tierThreePointsLabel = UILabel()
    
    var pointsLabel2 = UILabel()
    
    func setupView1(){
        tierOne = UIView(frame: CGRect(x: 20, y: (UIScreen.main.bounds.height * 0.36), width: (UIScreen.main.bounds.width / 3) - (70/3), height: ((UIScreen.main.bounds.width / 3) - (70/3)) * 1.56))
        tierOne.backgroundColor = .white
        tierOne.layer.cornerRadius = 11
        tierOne.clipsToBounds = true
        tierOne.layer.shadowRadius = 3
        tierOne.layer.shadowOpacity = 0.95
        tierOne.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        tierOne.layer.masksToBounds = false
        tierOne.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        let tierOneCreditsImage = UIImageView(frame: CGRect(x: (tierOne.frame.width / 2) - 35, y: 29.5, width: 20, height: 20))
//        tierOneCreditsImage.contentMode = .scaleAspectFit
//        tierOneCreditsImage.tintColor = .systemYellow
//        tierOneCreditsImage.clipsToBounds = true
//        tierOneCreditsImage.image = UIImage(systemName: "diamond.fill")
        
        let tierOnePointsLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 30, y: 23, width: 60, height: 29))
        tierOnePointsLabel.text = "100"
        tierOnePointsLabel.textColor = .black
        tierOnePointsLabel.textAlignment = .center
        tierOnePointsLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let pointsLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 36, y: 55, width: 72, height: 17))
        
        pointsLabel.text = "CREDITS"
        pointsLabel.textColor = .darkGray
        pointsLabel.textAlignment = .center
        pointsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let tierOnePriceLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 30.5, y: (tierOne.frame.height) - 41.5, width: 61, height: 26.5))
        tierOnePriceLabel.text = "$0.99"
        tierOnePriceLabel.textColor = .black
        tierOnePriceLabel.textAlignment = .center
        tierOnePriceLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        tierOne.addSubview(tierOnePointsLabel)
       // tierOne.addSubview(tierOneCreditsImage)
        tierOne.addSubview(pointsLabel)
        tierOne.addSubview(tierOnePriceLabel)
        tierOne.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(purchase100))
        tierOne.addGestureRecognizer(tap)
        view.addSubview(tierOne)
        
        let tierTwo = UIView(frame: CGRect(x: tierOne.frame.maxX + 15, y: (UIScreen.main.bounds.height * 0.36), width: (UIScreen.main.bounds.width / 3) - (70/3), height: ((UIScreen.main.bounds.width / 3) - (70/3)) * 1.56))
        tierTwo.backgroundColor = .white
        tierTwo.layer.cornerRadius = 11
        tierTwo.clipsToBounds = true
        tierTwo.layer.shadowRadius = 3
        tierTwo.layer.shadowOpacity = 0.95
        tierTwo.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        tierTwo.layer.masksToBounds = false
        tierTwo.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        let tierTwoPointsLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 30, y: 23, width: 60, height: 29))
        tierTwoPointsLabel.text = "550"
        tierTwoPointsLabel.textColor = .black
        tierTwoPointsLabel.textAlignment = .center
        tierTwoPointsLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let pointsLabel1 = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 36, y: 55, width: 72, height: 17))
        
        pointsLabel1.text = "CREDITS"
        pointsLabel1.textColor = .darkGray
        pointsLabel1.textAlignment = .center
        pointsLabel1.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let tierTwoPriceLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 35.5, y: (tierOne.frame.height) - 41.5, width: 71, height: 26.5))
        tierTwoPriceLabel.text = "$4.99"
        tierTwoPriceLabel.textColor = .black
        tierTwoPriceLabel.textAlignment = .center
        tierTwoPriceLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        tierTwo.addSubview(tierTwoPointsLabel)
        tierTwo.addSubview(pointsLabel1)
        tierTwo.addSubview(tierTwoPriceLabel)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(purchase550))
        tierTwo.addGestureRecognizer(tap2)
        view.addSubview(tierTwo)
        
        tierThree = UIView(frame: CGRect(x: tierTwo.frame.maxX + 15, y: (UIScreen.main.bounds.height * 0.36), width: (UIScreen.main.bounds.width / 3) - (70/3), height: ((UIScreen.main.bounds.width / 3) - (70/3)) * 1.56))
        tierThree.backgroundColor = .white
        tierThree.layer.cornerRadius = 11
        tierThree.clipsToBounds = true
        tierThree.layer.shadowRadius = 3
        tierThree.layer.shadowOpacity = 0.95
        tierThree.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        tierThree.layer.masksToBounds = false
        tierThree.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        tierThreePointsLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 40, y: 23, width: 80, height: 29))
        tierThreePointsLabel.text = "1,200"
        tierThreePointsLabel.textColor = .black
        tierThreePointsLabel.textAlignment = .center
        tierThreePointsLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        pointsLabel2 = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 36, y: 55, width: 72, height: 17))
        
        pointsLabel2.text = "CREDITS"
        pointsLabel2.textColor = .darkGray
        pointsLabel2.textAlignment = .center
        pointsLabel2.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        tierThreePriceLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 30.5, y: (tierOne.frame.height) - 41.5, width: 61, height: 26.5))
        tierThreePriceLabel.text = "$9.99"
        tierThreePriceLabel.textColor = .black
        tierThreePriceLabel.textAlignment = .center
        tierThreePriceLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        tierThree.addSubview(tierThreePointsLabel)
        tierThree.addSubview(pointsLabel2)
        tierThree.addSubview(tierThreePriceLabel)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(purchase1200))
        tierThree.addGestureRecognizer(tap3)
        view.addSubview(tierThree)
    }
    
    @objc func purchase100() {
       
        
        let defaults = UserDefaults.standard
        
        
        defaults.set(true, forKey: "credits_100")
        IAPManager.shared.purchase(product: .credits_100)
        updatePoints()
    }
    
    @objc func purchase550() {
        let defaults = UserDefaults.standard
        
        
        defaults.set(true, forKey: "credits_550")
        IAPManager.shared.purchase(product: .credits_550)
        self.updatePoints()
    }
    
    @objc func purchase1200() {
        tierThree.backgroundColor = .tintColor
        tierThreePriceLabel.textColor = .white
        tierThreePointsLabel.textColor = .white
        pointsLabel2.textColor = .white
        
        let defaults = UserDefaults.standard
        
        
        defaults.set(true, forKey: "credits_1200")
        IAPManager.shared.purchase(product: .credits_1200)
        updatePoints()
    }
    
    @objc func purchase2500() {
        let defaults = UserDefaults.standard
        
        
        defaults.set(true, forKey: "credits_2500")
        IAPManager.shared.purchase(product: .credits_2500)
        updatePoints()
    }
    
    @objc func purchase5200() {
        let defaults = UserDefaults.standard
        
        
        defaults.set(true, forKey: "credits_5200")
        IAPManager.shared.purchase(product: .credits_5200)
        updatePoints()
    }
    
    @objc func purchase14500() {
        let defaults = UserDefaults.standard
        
        
        defaults.set(true, forKey: "credits_14500")
        IAPManager.shared.purchase(product: .credits_14500)
        updatePoints()
    }
    
    func updatePoints(){
        let delay = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
            FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
                self.userPointsLabel.text = "\(user?.points ?? 0)"
            }
        }
    }
    
    func setupView2(){
        let tierFour = UIView(frame: CGRect(x: 20, y: self.tierOne.frame.maxY + 33, width: (UIScreen.main.bounds.width / 3) - (70/3), height: ((UIScreen.main.bounds.width / 3) - (70/3)) * 1.56))
        tierFour.backgroundColor = .white
        tierFour.layer.cornerRadius = 11
        tierFour.clipsToBounds = true
        tierFour.layer.shadowRadius = 3
        tierFour.layer.shadowOpacity = 0.95
        tierFour.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        tierFour.layer.masksToBounds = false
        tierFour.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        let tierFourPointsLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 40, y: 23, width: 80, height: 29))
        tierFourPointsLabel.text = "2,500"
        tierFourPointsLabel.textColor = .black
        tierFourPointsLabel.textAlignment = .center
        tierFourPointsLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let pointsLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 36, y: 55, width: 72, height: 17))
        
        pointsLabel.text = "CREDITS"
        pointsLabel.textColor = .darkGray
        pointsLabel.textAlignment = .center
        pointsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let tierFourPriceLabel = UILabel(frame: CGRect(x: (tierOne.frame.width / 2) - 40.5, y: (tierOne.frame.height) - 41.5, width: 81, height: 26.5))
        tierFourPriceLabel.text = "$19.99"
        tierFourPriceLabel.textColor = .black
        tierFourPriceLabel.textAlignment = .center
        tierFourPriceLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        tierFour.addSubview(tierFourPointsLabel)
        tierFour.addSubview(pointsLabel)
        tierFour.addSubview(tierFourPriceLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(purchase2500))
        tierFour.addGestureRecognizer(tap)
        view.addSubview(tierFour)
        
        let tierFive = UIView(frame: CGRect(x: tierFour.frame.maxX + 15, y: self.tierOne.frame.maxY + 33, width: (UIScreen.main.bounds.width / 3) - (70/3), height: ((UIScreen.main.bounds.width / 3) - (70/3)) * 1.56))
        tierFive.backgroundColor = .white
        tierFive.layer.cornerRadius = 11
        tierFive.clipsToBounds = true
        tierFive.layer.shadowRadius = 3
        tierFive.layer.shadowOpacity = 0.95
        tierFive.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        tierFive.layer.masksToBounds = false
        tierFive.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        let tierFivePointsLabel = UILabel(frame: CGRect(x: (tierFour.frame.width / 2) - 40, y: 23, width: 80, height: 29))
        tierFivePointsLabel.text = "5,200"
        tierFivePointsLabel.textColor = .black
        tierFivePointsLabel.textAlignment = .center
        tierFivePointsLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let pointsLabel1 = UILabel(frame: CGRect(x: (tierFour.frame.width / 2) - 36, y: 55, width: 72, height: 17))
        
        pointsLabel1.text = "CREDITS"
        pointsLabel1.textColor = .darkGray
        pointsLabel1.textAlignment = .center
        pointsLabel1.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let tierFivePriceLabel = UILabel(frame: CGRect(x: (tierFour.frame.width / 2) - 40.5, y: (tierOne.frame.height) - 41.5, width: 81, height: 26.5))
        tierFivePriceLabel.text = "$39.99"
        tierFivePriceLabel.textColor = .black
        tierFivePriceLabel.textAlignment = .center
        tierFivePriceLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        tierFive.addSubview(tierFivePointsLabel)
        tierFive.addSubview(pointsLabel1)
        tierFive.addSubview(tierFivePriceLabel)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(purchase5200))
        tierFive.addGestureRecognizer(tap2)
        view.addSubview(tierFive)
        
        let tierSix = UIView(frame: CGRect(x: tierFive.frame.maxX + 15, y: self.tierOne.frame.maxY + 33, width: (UIScreen.main.bounds.width / 3) - (70/3), height: ((UIScreen.main.bounds.width / 3) - (70/3)) * 1.56))
        tierSix.backgroundColor = .white
        tierSix.layer.cornerRadius = 11
        tierSix.clipsToBounds = true
        tierSix.layer.shadowRadius = 3
        tierSix.layer.shadowOpacity = 0.95
        tierSix.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        tierSix.layer.masksToBounds = false
        tierSix.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        let tierSixPointsLabel = UILabel(frame: CGRect(x: (tierFour.frame.width / 2) - 40, y: 23, width: 80, height: 29))
        tierSixPointsLabel.text = "14,500"
        tierSixPointsLabel.textColor = .black
        tierSixPointsLabel.textAlignment = .center
        tierSixPointsLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let pointsLabel2 = UILabel(frame: CGRect(x: (tierFour.frame.width / 2) - 36, y: 55, width: 72, height: 17))
        
        pointsLabel2.text = "CREDITS"
        pointsLabel2.textColor = .darkGray
        pointsLabel2.textAlignment = .center
        pointsLabel2.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let tierSixPriceLabel = UILabel(frame: CGRect(x: (tierFour.frame.width / 2) - 40.5, y: (tierOne.frame.height) - 41.5, width: 81, height: 26.5))
        tierSixPriceLabel.text = "$99.99"
        tierSixPriceLabel.textColor = .black
        tierSixPriceLabel.textAlignment = .center
        tierSixPriceLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        tierSix.addSubview(tierSixPointsLabel)
        tierSix.addSubview(pointsLabel2)
        tierSix.addSubview(tierSixPriceLabel)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(purchase14500))
        tierSix.addGestureRecognizer(tap3)
        view.addSubview(tierSix)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func purchaseAction(_ sender: Any) {
    }
    
    @objc func selectView(){
        tierOneView.backgroundColor = .tintColor
        tierOneView.tintColor = .white
    }
}
