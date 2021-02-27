//
//  WebViewControllerWine.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/07/29.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit
import WebKit

class WebViewControllerWine: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 表示するWEBサイトのURLを設定します。
        let url = URL(string:"https://qiita.com/Vagrants/items/9487aecfd9509d039391")
        let urlRequest = URLRequest(url: url!)
        // test
        webView.allowsLinkPreview = false
        //　デリゲートが持っているメソッドを使えるようにする
        webView.navigationDelegate = self
        // webViewで表示するWEBサイトの読み込みを開始します。
        webView.load(urlRequest)
        // スワイプバック
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webView.estimatedProgress);
            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if (self.webView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3,
                               delay: 0.3,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: {
                        (finished : Bool) in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    // WEBサイトから応答が返ってきてから呼ばれる
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let allowedURL = "https://qiita.com/Vagrants/items/9487aecfd9509d039391"
        if webView.url?.absoluteString == allowedURL {  // 使い方のqiitaのページなら遷移を許可
            print ("allow", allowedURL, webView.url?.absoluteString as Any)
            decisionHandler(.allow)
        } else {  // それ以外のページは遷移を禁止
            print ("cancel", allowedURL, webView.url?.absoluteString as Any)
            decisionHandler(.cancel)
        }
    }
    // WEBサイトの読み込みを開始する時に呼ばれる
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // インジケータの表示を開始する
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    // WEBサイトの読み込みを完了した時に呼ばれる
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // インジケータの表示を終了する
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
