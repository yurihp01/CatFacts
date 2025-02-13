//
//  FactsListTableView.swift
//  CatFacts
//
//  Created by Yuri on 11/02/25.
//

import UIKit

class FactsListCell: UITableViewCell {
    // MARK: - Declarations
    static let identifier = "FactsListCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var verifiedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "verified")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var recentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "new")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - inits & local functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(verticalStackView)
        
        horizontalStackView.addArrangedSubview(verifiedImage)
        horizontalStackView.addArrangedSubview(recentImage)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDescription(with description: String) {
        titleLabel.text = description
    }
    
    func setIcons(showVerifiedImage: Bool, showRecentImage: Bool) {
        verifiedImage.isHidden = !showVerifiedImage
        recentImage.isHidden = !showRecentImage
    }
}

// MARK: - Private ext
private extension FactsListCell {
    func configureConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            verifiedImage.widthAnchor.constraint(equalToConstant: 32),
            verifiedImage.heightAnchor.constraint(equalToConstant: 32),
            
            recentImage.widthAnchor.constraint(equalToConstant: 32),
            recentImage.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
