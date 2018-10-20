//
//  ViewController.swift
//  Tunes
//
//  Created by Abraham Omorogbe on 2018-10-20.
//  Copyright © 2018 Abraham Omorogbe. All rights reserved.
//
import Foundation
import UIKit
import AVKit

class SongsViewController: UITableViewController {

    var songs = [Song]()
    
   func performSearch(with query:String){
       Song.search(with: query, completionHandler: { songs in
            print(songs)
        self.songs = songs
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        })
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }
    
    override func tableView(
        _ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let song = songs[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "songCell")
        
        cell.textLabel?.text = song.trackName
        cell.detailTextLabel?.text = "by \(song.artistName)"
        
        return cell
    }
    @IBAction func searchButtonPresed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Search",
            message:nil,
            preferredStyle: .alert
        )
        
        alert.addTextField {textField in
            textField.placeholder = "Email/User Name"
        }
        
        alert.addTextField {textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title: "Search",
            style: .default,
            handler: {_ in
            
        guard let text = alert.textFields?.first?.text,
        !text.isEmpty else {
            return
        }
        guard let text2 = alert.textFields?.last?.text,
        !text.isEmpty else {
            return
        }
            print(text)
            print(text2)
            self.performSearch(with: text)
                
        }))
         present(alert, animated:true)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: URL(string: song.previewUrl)!)
        playerController.player = player
        
        present(playerController, animated: true,
                completion: {player.play()
                    
        })
        
        if let data = try? Data(contentsOf: URL(string: song.artworkUrl)!),
            let artwork = UIImage(data: data)
        
        {
            let imageView = UIImageView(image:artwork)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            
            let contentView = playerController.contentOverlayView!
            contentView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
                ])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute:
                {playerController.dismiss(animated: true)
            })
        }
    }
}
