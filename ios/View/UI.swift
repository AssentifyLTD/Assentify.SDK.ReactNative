

protocol ChildViewControllerDelegate: AnyObject {
    func dismissParentViewController()
}


func showNavigationBarWithBackArrow(view: UIView, target: Any?, action: Selector?, initialTextColorHex: String, initialBackgroundColorHex: String, title: String ){
    let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: view.frame.size.width, height: 50))
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    navigationBar.backgroundColor = .clear
    
    let navigationItem = UINavigationItem()
    let backButton = UIButton(type: .custom)
    backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    backButton.tintColor = UIColor(hexString: initialTextColorHex)
    backButton.contentHorizontalAlignment = .center
    backButton.addTarget(target, action: action!, for: .touchUpInside)
    
    let buttonSize: CGFloat = 40
    backButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
    
    backButton.backgroundColor = UIColor(hexString: initialBackgroundColorHex)
    backButton.layer.cornerRadius = buttonSize / 2
    backButton.layer.masksToBounds = true
    
    let backButtonItem = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = backButtonItem
    
    navigationItem.title = title
    let titleAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(hexString: initialTextColorHex),
        .font: UIFont.systemFont(ofSize: 22)

    ]
    navigationBar.titleTextAttributes = titleAttributes
    
    navigationBar.items = [navigationItem]
    view.addSubview(navigationBar)
}




func showInfo(view: UIView, text: String, initialTextColorHex: String, initialBackgroundColorHex: String, initialImageName: String) -> (UILabel, UIImageView) {
    
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = UIColor(hexString: initialBackgroundColorHex)
    containerView.layer.cornerRadius = 20
    containerView.layer.masksToBounds = true
    
    let label = UILabel()
    label.text = text
    label.numberOfLines = 2
    label.font = UIFont.boldSystemFont(ofSize:16)
    label.textColor = UIColor(hexString: initialTextColorHex)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let imageView = UIImageView()
    imageView.image = UIImage(named: initialImageName)
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(imageView)
    containerView.addSubview(label)
    
    
    view.addSubview(containerView)
    
    NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
    ])
    
    NSLayoutConstraint.activate([
        imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
        imageView.widthAnchor.constraint(equalToConstant: 30),
        imageView.heightAnchor.constraint(equalToConstant: 30)
    ])
    
    NSLayoutConstraint.activate([
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
    ])
    
    return (label, imageView)
}



func showPopUpMessage(view: UIView, title: String, subTitle: String, initialTextColorHex: String, initialBackgroundColorHex: String, iconName: String, isGif: Bool, target: Any?, action: Selector?) -> UIView {
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = UIColor(hexString: initialBackgroundColorHex)
    containerView.layer.cornerRadius = 20
    containerView.layer.masksToBounds = true

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false

    let imageView = UIImageView()
    if isGif, let gifImage = UIImage.gifImageWithName(iconName) {
        imageView.image = gifImage
    } else {
        imageView.image = UIImage(named: iconName)
    }
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.textColor = UIColor(hexString: initialTextColorHex)
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    let subtitleLabel = UILabel()
    subtitleLabel.text = subTitle
    subtitleLabel.font = UIFont.systemFont(ofSize: 14)
    subtitleLabel.textColor = UIColor(hexString: initialTextColorHex)
    subtitleLabel.textAlignment = .center
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

    let retryButton = UIButton(type: .system)
    retryButton.setTitle("RETRY ?", for: .normal)
    retryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    retryButton.setTitleColor(UIColor(hexString: initialBackgroundColorHex), for: .normal)
    retryButton.backgroundColor = UIColor(hexString: initialTextColorHex)
    retryButton.layer.cornerRadius = 20
    retryButton.clipsToBounds = true
    retryButton.translatesAutoresizingMaskIntoConstraints = false
    let retryButtonTopPadding: CGFloat = 3
    let paddingView = UIView()
    paddingView.translatesAutoresizingMaskIntoConstraints = false
    paddingView.heightAnchor.constraint(equalToConstant: retryButtonTopPadding).isActive = true
    if let action = action {
        retryButton.addTarget(target, action: action, for: .touchUpInside)
    }

    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    if(!isGif && iconName != "sending"){
        stackView.addArrangedSubview(paddingView)
        stackView.addArrangedSubview(retryButton)
    }

    containerView.addSubview(stackView)
    view.addSubview(containerView)

    NSLayoutConstraint.activate([
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
    ])

    NSLayoutConstraint.activate([
        imageView.widthAnchor.constraint(equalToConstant: 90),
        imageView.heightAnchor.constraint(equalToConstant: 70)
    ])

    NSLayoutConstraint.activate([
        retryButton.widthAnchor.constraint(equalToConstant: 100),
        retryButton.heightAnchor.constraint(equalToConstant: 40)
    ])

    NSLayoutConstraint.activate([
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        containerView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
        containerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5)
    ])
    
    let tapGesture = UITapGestureRecognizer(target: target, action: action)
    containerView.addGestureRecognizer(tapGesture)
    containerView.isUserInteractionEnabled = true

    return containerView
}


func showFlippingCard(view: UIView) -> UIView {
    let containerView = UIView()
       containerView.translatesAutoresizingMaskIntoConstraints = false
       containerView.backgroundColor = UIColor.clear // Set to clear or any desired background color
       containerView.layer.cornerRadius = 20
       containerView.layer.masksToBounds = true

       let imageView = UIImageView()
    let gifImage = UIImage.gifImageWithName("card")
       imageView.image = gifImage
     
       imageView.contentMode = .scaleAspectFit
       imageView.translatesAutoresizingMaskIntoConstraints = false

       containerView.addSubview(imageView)
       view.addSubview(containerView)

       NSLayoutConstraint.activate([
           imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
           imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
           imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
           imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
           imageView.widthAnchor.constraint(equalToConstant: 400),
           imageView.heightAnchor.constraint(equalToConstant: 400)
       ])

       NSLayoutConstraint.activate([
           containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
           containerView.heightAnchor.constraint(equalTo: imageView.heightAnchor)
       ])
       
       containerView.isUserInteractionEnabled = true

       return containerView
}




extension UIColor {
    convenience init?(hexString: String) {
        var hexFormatted: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        if hexFormatted.count == 6 {
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
            return
        }
        
        return nil
    }
}
extension UIImage {
    class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return UIImage.gifImageWithData(imageData)
    }
    
    class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration = 0.0
        
        for i in 0..<count {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any] else {
                continue
            }
            guard let gifDictionary = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else {
                continue
            }
            guard let gifDelayTime = gifDictionary[kCGImagePropertyGIFDelayTime as String] as? Double else {
                continue
            }
            duration += gifDelayTime
            images.append(UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up))
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
}
