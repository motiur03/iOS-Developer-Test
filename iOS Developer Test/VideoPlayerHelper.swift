//
//  VideoPlayerHelper.swift
//  iOS Developer Test
//
//  Created by Motiur Rahaman on 2023-01-20.
//

import Foundation
import AVKit

var videoPlayer: AVPlayer?

func playVideo(fileName:String)-> AVPlayer {
   
        videoPlayer = AVPlayer(url: URL(string: fileName)!)
        //videoPlayer?.play()
        
    return videoPlayer!
}
func pauseVideo(fileName:String)-> AVPlayer {
   
        videoPlayer = AVPlayer(url: URL(string: fileName)!)
    videoPlayer?.pause()
        
    return videoPlayer!
}
