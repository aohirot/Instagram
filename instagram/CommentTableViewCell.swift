//
//  CommentTableViewCell.swift
//  instagram
//
//  Created by Hiromichi Aoki on 11/30/20.
//  Copyright © 2020 Hiromichi Aoki. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // PostDataの内容をセルに表示
    func setCommentPostData(_ postData: PostData) {
    
        //コメントの表示
        let typedComment = postData.comment
        var withoutCamma = ""
        for i in 0...typedComment.count - 1 {
            withoutCamma += typedComment[i]
            //
            print(typedComment[i])
            self.commentLabel.text = "\(typedComment[i])"
        }
    }
}
//\(String(describing: postData.name!)):
