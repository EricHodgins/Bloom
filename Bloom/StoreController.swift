//
//  StoreController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import StoreKit

class StoreController: UIViewController, IAPManagerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var csvButton: GenericBloomButton!
    @IBOutlet weak var csvPurchaseDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        csvButton.isEnabled = false
        csvPurchaseDescriptionTextView.isHidden = true
        activityIndicator.startAnimating()
        
        IAPManager.shared.delegate = self
        if let _ = UserDefaults.standard.object(forKey: "IAPCapable") {
            fetchProducts()
        } else {
            checkIAPCapable()
        }
    }
    
    func productsRequestResponseCompleted() {
        activityIndicator.stopAnimating()
        csvButton.isEnabled = true
        setCSVButtonTitle()
    }
    
    func checkIAPCapable() {
        IAPManager.shared.setupPurchases { (success) in
            if success {
                self.fetchProducts()
                UserDefaults.standard.set(true, forKey: "IAPCapable")
                UserDefaults.standard.synchronize()
            } else {
                //TODO: Change UI
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func fetchProducts() {
        IAPManager.shared.requestProducts() 
    }
    
    func setCSVButtonTitle() {
        csvPurchaseDescriptionTextView.isHidden = false
        csvButton.titleLabel?.lineBreakMode = .byWordWrapping
        csvButton.titleLabel?.textAlignment = .center
        let csvProduct = IAPManager.shared.products[0]
        let csvButtonTitle = csvProduct.localizedTitle + "\n" + priceStringForProduct(product: csvProduct)
        csvButton.setTitle(csvButtonTitle, for: .normal)
    }
    
    func priceStringForProduct(product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price)!
    }
    
    @IBAction func donePushed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func csvButtonPushed(_ sender: Any) {
        guard IAPManager.shared.products.count > 0 else { return }
        
        let product = IAPManager.shared.products[0]
        IAPManager.shared.createPaymentRequestForProduct(product: product)
    }
    
}

























