protocol ChildViewControllerDelegate: AnyObject {
    func dismissParentViewController()
}


func showNavigationBarWithBackArrow(title: String, view: UIView, target: Any?, action: Selector?) {
    let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 28, width: view.frame.size.width, height: 50))
    navigationBar.backgroundColor = UIColor(named: "#f5a103")
    navigationBar.barTintColor = UIColor(named: "#f5a103")
    navigationBar.tintColor = .white

    let padding: CGFloat = 30

    // Title Label
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.textAlignment = .center
    titleLabel.sizeToFit()
    titleLabel.frame.origin.y = padding
    titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
    titleLabel.frame.size.width = navigationBar.frame.size.width

    // Title View
    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: navigationBar.frame.size.width, height: 70 + padding)) // Adjusted height to include padding
    titleView.addSubview(titleLabel)

    // Navigation Item
    let navigationItem = UINavigationItem()

    // Back Button with chevron.left image
    let backButton = UIButton(type: .custom)
    backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    backButton.frame = CGRect(x: 0, y: padding, width: 40, height: 40) // Adjusted position and size
    backButton.addTarget(target, action: action!, for: .touchUpInside)
    let backButtonItem = UIBarButtonItem(customView: backButton)

    navigationItem.leftBarButtonItem = backButtonItem

    // Set Navigation Item
    navigationBar.items = [navigationItem]


    view.addSubview(navigationBar)
}

func showInfo(view: UIView,text: String, initialTextColorHex: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: initialTextColorHex)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])

        return label
    }
