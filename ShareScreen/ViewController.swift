//
//  ViewController.swift
//  ShareScreen
//
//  Created by TIAGO ALMEIDA DE OLIVEIRA on 11/08/20.
//  Copyright © 2020 TIAGO ALMEIDA DE OLIVEIRA. All rights reserved.
//

import UIKit
import WebKit

enum Key: String {
    case paperRect
    case printableRect
}

class ViewController: UIViewController {
    
    // MARK: - Constants
    private let defaultURL = "https://www.apple.com.br"
    var webImage: UIImage?
    
    private lazy var wkWebView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let size = self.view.frame
        let webView = WKWebView(frame: size, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var urlTextField: UITextField! {
        didSet {
            urlTextField.placeholder = "Enter a url"
            urlTextField.text = defaultURL
        }
    }
    
    @IBOutlet weak var webView: UIView! {
        didSet {
            webView.addSubview(wkWebView)
            wkWebView.translatesAutoresizingMaskIntoConstraints = false
            wkWebView.snapAllConstraints(toView: webView, horizontalDistance: CGFloat.zero, verticalDistance: CGFloat.zero)
        }
    }
    
    @IBOutlet weak var gotoButton: UIButton! {
        didSet {
            gotoButton.setTitle("Go", for: .normal)
        }
    }
    
    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadURL(fromURLString: defaultURL)
    }
    
    // MARK: - Actions
    @IBAction func gotoTapped(_ sender: UIButton) {
        guard let url = urlTextField.text, !url.isEmpty else {
            return
        }
        loadURL(fromURLString: url)
    }
    
    @IBAction func shareTap(_ sender: UIButton) {
        shareFullSnapshot()
    }
    
    // MARK: - Private
    private func loadURL(fromURLString urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }

    private func shareSnapshot() {
        wkWebView.takeSnapshot(with: nil) { (image, error) in
            guard let image = image else {
                print("Image not found")
                return
            }
            let shareText = "WebView Share Screen"
            self.share(withTitle: shareText, activityItems: [image])
        }
    }
    
    private func shareFullSnapshot() {
        wkWebView.takePDF { (pdf) in
            let shareText = "WebView Share Full screen"
            self.share(withTitle: shareText, activityItems: [pdf])
        }
    }
    
    private func share(withTitle shareText: String, activityItems items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: [])
        activityController.transitioningDelegate = self
        self.present(activityController, animated: true)
    }
}

// MARK: - WKUIDelegate
extension ViewController: WKUIDelegate {
    
}

// MARK: - WKNavigationDelegate
extension ViewController: WKNavigationDelegate {

}

// MARK: - UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
    
}

extension WKWebView {
    
    func takePDF(completion: @escaping(Data) -> Void) {
        let paperWidth = CGFloat(595.2)
        let paperHeight = CGFloat(841.8)
        let startPage = Int(0)
        let xPos = CGFloat(0)
        let yPos = CGFloat(0)
        
        
        let printFormatter = self.viewPrintFormatter()
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(printFormatter, startingAtPageAt: startPage)
        
        let a4 = CGSize(width: paperWidth, height: paperHeight)
        let paperRect = CGRect(x: xPos, y: yPos, width: a4.width, height: a4.height)
        
        renderer.setValue(paperRect, forKey: Key.paperRect.rawValue)
        renderer.setValue(paperRect, forKey: Key.printableRect.rawValue)
        
        let pdfData = renderer.makePDF()
        completion(pdfData)
    }
    
}

extension UIPrintPageRenderer {
    
    public func makePDF() -> Data {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, paperRect, nil)
        prepare(forDrawingPages: NSMakeRange(0, numberOfPages))
        let bounds = UIGraphicsGetPDFContextBounds()
        for i in 0 ..< numberOfPages {
            UIGraphicsBeginPDFPage()
            drawPage(at: i, in: bounds)
        }
        UIGraphicsEndPDFContext()
        return data as Data
    }
    
}
