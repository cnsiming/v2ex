//
//  NewCommentViewController.swift
//  v2ex
//
//  Created by wjb on 2018/4/23.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

protocol NewCommentViewControllerDelegate: class {

    func newCommentViewControllerDidCancel(_ controller: NewCommentViewController)
    func newCommentViewController(_ controller: NewCommentViewController, didFinishSubmitting comment: String)
}

class NewCommentViewController: UIViewController {

    var post: Post?
    weak var delegate: NewCommentViewControllerDelegate?

    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var commentTextView: UITextView!

    @IBAction func close(_ sender: Any) {
        commentTextView.resignFirstResponder()
        delegate?.newCommentViewControllerDidCancel(self)
    }

    @IBAction func submit(_ sender: Any) {
        guard let comment = commentTextView.text else {
            return
        }

        commentTextView.resignFirstResponder()

        let hudView = HUDView.hud(inView: view, hudType: .loading)
        hudView.text = "正在提交"

        post?.submit(comment: comment) { [weak self] result in
            self?.delegate?.newCommentViewController(self!, didFinishSubmitting: comment)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.delegate = self
        commentTextView.becomeFirstResponder()
    }

}

extension NewCommentViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        submitButton.isEnabled = textView.text.count > 0
    }

}
