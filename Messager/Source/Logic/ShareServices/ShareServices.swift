//
//  ShareServices.swift
//  Messager
//
//  Created by Silchenko on 26.12.2018.
//

import UIKit
import FacebookShare
import MessageUI

class ShareServices: NSObject {
    
    func shareFacebook(image: UIImage, from viewController: UIViewController) {
        let photo = Photo(image: image, userGenerated: true)
        let content = PhotoShareContent(photos: [photo])
        do {
            try ShareDialog.show(from: viewController, content: content)
        } catch {
            print("Error")
        }
    }
    
    func shareGmail(viewController: UIViewController, image: UIImage) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setSubject("Image")
        composeVC.setMessageBody("", isHTML: false)
        composeVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
        viewController.present(composeVC, animated: true, completion: nil)
    }
}

extension ShareServices: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
