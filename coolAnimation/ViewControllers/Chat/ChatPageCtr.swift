//
//  chatPage.swift
//  coolAnimation
//
//  Created by Andrew on 7/12/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import CoreData

class ChatPageController: UICollectionViewController  , UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @objc var userNameAddContact: User?{
        didSet{
            
            self.userLabel.text = self.userNameAddContact?.name
            self.navigationItem.titleView = self.userLabel
            observerMessages()
            
        }
    }
    
    @objc let cellId = "cellId"
    @objc var message = [Messages]()
    @objc var messageCoreData = [ChatInfoModel]()
    @objc var manajedObjectContext: NSManagedObjectContext!
    
    
    
    @objc lazy var chatBox: UITextField = { //uitextview
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Send a message to...."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
//        textField.isScrollEnabled = false
//        textField.delegate = self
        return textField
    }()
    
    @objc let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    @objc let imagePickerSend: UIImageView = {
        let image = UIImage(named: "photo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc let separator: UIView = {
        let linie = UIView()
        linie.translatesAutoresizingMaskIntoConstraints = false
        linie.backgroundColor = UIColor.black
        return linie
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
//        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(MessageCollCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(chatBox)
        view.addSubview(sendButton)
        view.addSubview(separator)
        view.addSubview(imagePickerSend)
        addConstraints()
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissView))
        manajedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let height = CGSize(width: view.frame.width, height: .infinity)
        let estimateHeight = textView.sizeThatFits(height)
        heightChatBox.constant = estimateHeight.height
    }
    
    
    var heightBottomchatBox: NSLayoutConstraint!
    var heightChatBox: NSLayoutConstraint!
    var heightBottomsendButton: NSLayoutConstraint!
    var heightBottomseparator: NSLayoutConstraint!
    var heightBottomimagePickerSend: NSLayoutConstraint!
    
    @objc func addConstraints(){
        self.sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        heightBottomsendButton = self.sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        heightBottomsendButton.isActive = true
        
        self.chatBox.leftAnchor.constraint(equalTo: self.imagePickerSend.rightAnchor).isActive = true
        heightChatBox = self.chatBox.heightAnchor.constraint(equalToConstant: 50)
        heightChatBox.isActive = true
        self.chatBox.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        heightBottomchatBox = self.chatBox.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        heightBottomchatBox.isActive = true
        
        heightBottomseparator = self.separator.bottomAnchor.constraint(equalTo: self.chatBox.topAnchor)
        heightBottomseparator.isActive = true
        self.separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.separator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.separator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        self.imagePickerSend.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.imagePickerSend.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.imagePickerSend.widthAnchor.constraint(equalToConstant: 48).isActive = true
        heightBottomimagePickerSend = self.imagePickerSend.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        heightBottomimagePickerSend.isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(dismissPage))
        tapped.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapped)
        
        let dismissTapp = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissTapp)
        
        let bringPhotosToSend = UITapGestureRecognizer(target: self, action: #selector(sendImage))
        imagePickerSend.addGestureRecognizer(bringPhotosToSend)
        
        let titleViewTapp = UITapGestureRecognizer(target: self, action: #selector(bringUp))
        self.userLabel.addGestureRecognizer(titleViewTapp)
        
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.pushToDetailView))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(findKeyboardHeight), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissKeyboard), name: .UIKeyboardDidHide, object: nil)
        
        
    }
    
    @objc func pushToDetailView(){
        let infoPage = ChatPageInfoController()
        infoPage.userInfoName = userNameAddContact?.name
        self.navigationController?.pushViewController(infoPage, animated: true)
    }
    
    @objc func handleKeyBoardDidShow(){
        if self.message.count > 0{
            let indexPath = NSIndexPath(item: self.message.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func didDismissKeyboard(){
        heightBottomchatBox.constant = 0
        heightBottomsendButton.constant = 0
        heightBottomimagePickerSend.constant = 0
        heightBottomseparator.constant = 0
    }
    
    @objc func bringUp(){
        print("yeah")
        if self.message.count > 0 {
            let indexPath = NSIndexPath(item: 1, section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    var duration: Double = 0
    @objc func findKeyboardHeight(note: Notification){
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            duration = (note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            heightBottomchatBox.constant = -keyboardSize.height
            heightBottomsendButton.constant = -keyboardSize.height
            heightBottomimagePickerSend.constant = -keyboardSize.height
            heightBottomseparator.constant = -keyboardSize.height + heightBottomchatBox.constant
            
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @objc func dismissPage(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(){
        heightBottomchatBox.constant = 0
        heightBottomsendButton.constant = 0
        heightBottomimagePickerSend.constant = 0
        heightBottomseparator.constant = 0
        
        
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.view.endEditing(true)
    }
    
    @objc func animateView(height: CGFloat){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -height - 30, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    @objc func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    let userLabel: UITextView = {
        let text = UITextView()
        text.backgroundColor = UIColor(white: 1,alpha: 0)
        text.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.isEditable = false
        return text
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var finalPicture: UIImage?
        
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL{
            let ref = Storage.storage().reference().child("movies")
            let fileName = NSUUID().uuidString
            let uploadTask = ref.child(fileName).putFile(from: videoUrl as URL, metadata: nil, completion: { (metadata, err) in
                if err != nil{
                    print(err!)
                    return
                }else{
                    ref.downloadURL(completion: { (fileNameUrl, err) in
                        if err != nil{
                            debugPrint(err?.localizedDescription)
                        }
                        if let thumbNailVideoUrlVar = self.thumbNailVideoUrl(videoUrl: videoUrl){
                            
                            self.uploadImageToFirebase(image: thumbNailVideoUrlVar, completion: { (imageUrl) in
                                let proprieties: [String: Any] = ["imageUrl": imageUrl,"videHeight": thumbNailVideoUrlVar.size.height, "videoWidth": thumbNailVideoUrlVar.size.width, "fileNameUrl": fileNameUrl?.absoluteString]
                                self.defaultSend(proprities: proprieties)
                            })
                        }
                    })
                }
            })
            
            uploadTask.observe(.progress, handler: { (snapshot) in
                if let completedUnitCount = snapshot.progress?.completedUnitCount {
                    self.navigationItem.title = String(completedUnitCount)
                }
            })
            
            uploadTask.observe(.success, handler: { (snapshot) in
                self.navigationItem.title = self.userNameAddContact?.name
            })
            
        }
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            finalPicture = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            finalPicture = originalImage
        }
        
        if let selectedPicture = finalPicture{
            uploadImageToFirebase(image: selectedPicture, completion: { (imageUrl) in
                self.sendMessageImageUrl(messageUrl: imageUrl,image: selectedPicture)
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func thumbNailVideoUrl(videoUrl: NSURL) -> UIImage? {
        let asset = AVAsset(url: videoUrl as URL)
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let when = CMTimeMake(1, 60)
            let thumbNailCGImage = try assetGenerator.copyCGImage(at: when, actualTime: nil)
            return UIImage(cgImage: thumbNailCGImage)
        }catch{
            print(error)
        }
        return nil
        
    }
    
    @objc func uploadImageToFirebase(image: UIImage?, completion: @escaping (_ imageUrl: String) -> ()){
        let imageName = NSUUID().uuidString
        let storage = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadDate = UIImageJPEGRepresentation(image!, 0.2){
            storage.putData(uploadDate, metadata: nil, completion: { (metadata, err) in
                if err != nil{
                    print(err!)
                }else{
                    storage.downloadURL(completion: { (imageUrl, err) in
                        if err != nil{
                            debugPrint(err?.localizedDescription)
                        }
                        completion((imageUrl?.absoluteString)!)
                    })
                }
            })
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! MessageCollCell
        DispatchQueue.main.async {
            
            let messageArray = self.message[indexPath.row]
            cell.textView.text = messageArray.text
            
            self.createCellLayout(cell: cell, messageArray: messageArray)
            
            cell.chatLogController = self
            cell.message = messageArray
            
            if let text = messageArray.text {
                cell.textView.isHidden = false
                cell.bubbleWidthAnchor?.constant = self.estimageFrameTextSize(text: text).width + 32
            } else if messageArray.imageUrl != nil{
                cell.textView.isHidden = true
                cell.bubbleWidthAnchor?.constant = 200
            }
            
            
        }
        return cell
        
    }
    
    @objc func createCellLayout(cell: MessageCollCell, messageArray: Messages){
        
        if let profileImageUrl = self.userNameAddContact?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheString(urlString: profileImageUrl)
        }
        
        if let messageImageUrl = messageArray.imageUrl {
            cell.messageImageView.loadImageUsingCacheString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
        }else{
            cell.messageImageView.isHidden = true
        }
        
        if messageArray.videoUrl != nil {
            cell.playButton.isHidden = false
        }else{
            cell.playButton.isHidden = true
        }
        
        if messageArray.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = MessageCollCell.bubbleColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
            
        }else{
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let messageVar = message[indexPath.item]
        if let text = messageVar.text {
            height = estimageFrameTextSize(text: text).height + 20
        }else if let imageWidth = messageVar.widthImage?.floatValue, let imageHeight = messageVar.heightImage?.floatValue{
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    @objc func estimageFrameTextSize(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    
    
    @objc func sendMessage(){
        DispatchQueue.main.async {
            if self.chatBox.text != ""{
                let proprieties: [String: Any] = ["text": self.chatBox.text!,"toId": self.userNameAddContact!.id!]
                self.defaultSend(proprities: proprieties)
            }
        }
        
    }
    @objc public func sendMessagesNotification(text: String!,toId: String!){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
        
        Database.database().reference().child("users").child(toId).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let imageUrl = dictionary["profilePicture"] as? String
                let values: [String:Any] = ["toId": toId, "toIdImageUrl": imageUrl!, "fromId": fromId!, "timeStamp": timeStamp,"text":text]
                childRef.updateChildValues(values, withCompletionBlock: { (err, reference) in
                    if err != nil{
                        print(err!)
                        return
                    }else{
                        
                        let newNodeRef = Database.database().reference().child("user-messages").child(fromId!)
                        let messageId = childRef.key
                        newNodeRef.updateChildValues([messageId: 1])
                        
                        
                        let receverUser = Database.database().reference().child("user-messages").child(toId)
                        receverUser.updateChildValues([messageId: 1])
                        self.chatBox.text = nil
                    }
                })
            }
        }, withCancel: nil)
    }
    private func sendMessageImageUrl(messageUrl: String,image: UIImage){
        let proprieties: [String: Any] = ["imageUrl": messageUrl ,"imageHeight":image.size.height,"imageWidth": image.size.width]
        defaultSend(proprities: proprieties)
    }
    
    func sendActiveMessage(messageActive: String){
        let proprieties: [String: Any] = ["active": messageActive]
        defaultSend(proprities: proprieties)
    }
    
    private func defaultSend(proprities: [String: Any]){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
        
        Database.database().reference().child("users").child(userNameAddContact!.id!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let imageUrl = dictionary["profilePicture"] as? String
                var values: [String: Any] = ["toId": self.userNameAddContact!.id!, "toIdImageUrl": imageUrl!, "fromId": fromId!, "timeStamp": timeStamp]
                
                proprities.forEach({values[$0] = $1})
                
                childRef.updateChildValues(values, withCompletionBlock: { (err, reference) in
                    if err != nil{
                        print(err!)
                        return
                    }else{
                        
                        let newNodeRef = Database.database().reference().child("user-messages").child(fromId!)
                        let messageId = childRef.key
                        newNodeRef.updateChildValues([messageId: 1])
                        
                        
                        let receverUser = Database.database().reference().child("user-messages").child(self.userNameAddContact!.id!)
                        receverUser.updateChildValues([messageId: 1])
                        self.chatBox.text = nil
                    }
                })
            }
        }, withCancel: nil)
    }
    
    
    @objc func observerMessages(){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("user-messages").child(uid!).observe(.childAdded, with: { (snapshot) in
            
            let realMessRef = Database.database().reference()
            let messageId = snapshot.key
            
            realMessRef.child("messages").child(messageId).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let message = Messages(dictionary: dictionary)
                    
                    if message.chatPartner() == self.userNameAddContact?.id {
                        self.message.append(message)
                        
                        DispatchQueue.main.async(execute: {
                            self.collectionView?.reloadData()
                            let indexPath = NSIndexPath(item: self.message.count - 1, section: 0)
                            self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                        })
                        
                    }
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    
    
    var startingFrame: CGRect?
    @objc var blackBackgroundView: UIView?
    @objc var startingImageView: UIImageView?
    
    
    @objc var playerLayer: AVPlayerLayer?
    @objc var player: AVPlayer?
    
    
    
    @objc func performZoomImage(startingImageView: UIImageView,videoUrl: String?){
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                self.blackBackgroundView?.alpha = 1
                self.chatBox.alpha = 0
                self.sendButton.alpha = 0
                self.imagePickerSend.alpha = 0
                self.separator.alpha = 0
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: { (completed) in
                
                if videoUrl != nil{
                    let actualURl = URL(string: videoUrl!)
                    self.player = AVPlayer(url: actualURl!)
                    self.playerLayer = AVPlayerLayer(player: self.player)
                    self.playerLayer?.frame = zoomingImageView.bounds
                    zoomingImageView.layer.addSublayer(self.playerLayer!)
                    self.player?.play()
                }
                
                
                
            })
            
            
        }
    }
    
    
    
    
    @objc func zoomOut(tap: UITapGestureRecognizer){
        if let zoomOutImageView = tap.view{
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.chatBox.alpha = 1
                self.sendButton.alpha = 1
                self.imagePickerSend.alpha = 1
                self.separator.alpha = 1
                self.playerLayer?.removeFromSuperlayer()
                self.player?.pause()
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
                
            })
            
        }
        
    }
    
}















