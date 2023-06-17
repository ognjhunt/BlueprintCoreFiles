//
//  IAPManager.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 12/5/22.
//

import Foundation
import StoreKit
import FirebaseAuth
import FirebaseFirestore

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    
    let db = Firestore.firestore()
    
    var products = [SKProduct]()
    
    enum Product: String, CaseIterable {
        case credits_100
        case credits_550
        case credits_1200
        case credits_2500
        case credits_5200
        case credits_14500
    }
    
    public func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Products returned \(response.products.count)")
        self.products = response.products
    }
    
    func purchase(product: Product) {
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product.rawValue }) else {
            return
        }
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)

    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                break
            case .purchased:
                let defaults = UserDefaults.standard
                if defaults.bool(forKey: "credits_100") == true {
                    let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef2.updateData([
                        "points": FieldValue.increment(Int64(100))
                    ])
                    defaults.set(false, forKey: "credits_100")
                } else if defaults.bool(forKey: "credits_550") == true {
                    let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef2.updateData([
                        "points": FieldValue.increment(Int64(550))
                    ])
                    defaults.set(false, forKey: "credits_550")
                } else if defaults.bool(forKey: "credits_1200") == true {
                    let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef2.updateData([
                        "points": FieldValue.increment(Int64(1200))
                    ])
                    defaults.set(false, forKey: "credits_1200")
                } else if defaults.bool(forKey: "credits_2500") == true {
                    let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef2.updateData([
                        "points": FieldValue.increment(Int64(2500))
                    ])
                    defaults.set(false, forKey: "credits_2500")
                } else if defaults.bool(forKey: "credits_5200") == true {
                    let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef2.updateData([
                        "points": FieldValue.increment(Int64(5200))
                    ])
                    defaults.set(false, forKey: "credits_5200")
                } else if defaults.bool(forKey: "credits_14500") == true {
                    let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef2.updateData([
                        "points": FieldValue.increment(Int64(14500))
                    ])
                    defaults.set(false, forKey: "credits_14500")
                }
                break
            case .failed:
                break
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
}
