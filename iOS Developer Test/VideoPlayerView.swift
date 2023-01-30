//
//  VideoPlayerView.swift
//  iOS Developer Test
//
//  Created by Motiur Rahaman on 2023-01-20.
//

import Foundation
import SwiftUI
import AVKit
import Network

@main
struct DownloadFilesLocallyApp: App {
    var downloadManager = DownloadManager()
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(downloadManager)
                .environmentObject(networkMonitor)
        }
    }
}

struct DownloadButton: View {
    @EnvironmentObject var downloadManager: DownloadManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showVideo = false
    private let total: Double = 1
    @State var urlStr: String
    
    func urlUpdate(url: String){
        urlStr = url
    }
    var body: some View {
        let colors: Array<Color> = downloadManager.isDownloaded ? (colorScheme == .dark ? [Color(#colorLiteral(red: 0.6196078431, green: 0.6784313725, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5607843137, blue: 0.9803921569, alpha: 1))] : [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1))]) : [Color.primary]
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 40){
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
                            .mask(Text(downloadManager.isDownloaded ? "Downloaded" : "Download").fontWeight(.semibold).textCase(.uppercase).font(.footnote).frame(maxWidth: .infinity, alignment: .leading))
                            .frame(maxHeight: 30)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(downloadManager.isDownloaded ? "Delete the downloaded file" : "Watch offline")
                                .font(.caption2)
                                .foregroundColor(Color.primary)
                                .opacity(0.7)
                        }
                        .frame(maxWidth: 200, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Group {
                        if downloadManager.isDownloading {
                            HStack(spacing: 8) {
                                VStack(){
                                    ProgressView()
                                    
                                    ProgressView("", value: downloadManager.progress, total: total)
                                        .progressViewStyle(LinearProgressViewStyle())
                                    //.padding()
                                }
                                Image(systemName:"trash")
                                    .onTapGesture {
                                        // downloadManager.urlString =
                                        downloadManager.cancelDownloading()
                                        downloadManager.isDownloading = false
                                        
                                    }
                            }
                            //                        ProgressView("", value: downloadAmount, total: 100)
                            //                            .onReceive(timer) { _ in
                            //                                            if downloadAmount < 100 {
                            //                                                downloadAmount += 2
                            //                                            }
                            //                                        }
                        } else {
                            Image(systemName: downloadManager.isDownloaded ? "trash" : "square.and.arrow.down")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color.primary)
                                .opacity(0.7)
                        }
                    }
                    .frame(width: 92, height: 52)
                    .overlay(Rectangle().stroke(style: StrokeStyle(lineWidth: 1)).opacity(0.1))
                    
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .background(colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.2) : Color(#colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 1, alpha: 1)))
                .cornerRadius(20)
                .onTapGesture {
                    // downloadManager.urlString =
                    downloadManager.isDownloaded ? downloadManager.deleteFile() : downloadManager.downloadFile()
                }
                if downloadManager.isDownloaded {
                    WatchButton()
                        .onTapGesture {
                            showVideo = true
                        }
                        .fullScreenCover(isPresented: $showVideo, content: {
                            VideoView()
                        })
                }
            }.padding(.horizontal, 20)
                .onAppear {
                    downloadManager.urlString = urlStr
                    downloadManager.checkFileExists()
                    
                }
            
        }

    }
}

struct WatchButton: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let colors: Array<Color> = colorScheme == .dark ? [Color(#colorLiteral(red: 0.6196078431, green: 0.6784313725, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5607843137, blue: 0.9803921569, alpha: 1))] : [Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]

        return HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
                    .mask(Text("Watch video").fontWeight(.semibold).textCase(.uppercase).font(.footnote).frame(maxWidth: .infinity, alignment: .leading))
                    .frame(maxHeight: 30)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Watch the downloaded video offline")
                        .font(.caption2)
                        .foregroundColor(Color.primary)
                        .opacity(0.7)
                }
                .frame(maxWidth: 300, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            }

            Image(systemName: "tv")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.primary)
                .opacity(0.7)
                .frame(width: 32, height: 32)
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1)).opacity(0.1))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.2) : Color(#colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 1, alpha: 1)))
        .cornerRadius(20)

    }
}
struct VideoView: View {
    @EnvironmentObject var downloadManager: DownloadManager
    @State var player = AVPlayer()

    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                let playerItem = downloadManager.getVideoFileAsset()
                if let playerItem = playerItem {
                    player = AVPlayer(playerItem: playerItem)
                }
                player.play()
            }
    }
}
struct VideoPlayerView: View {
    @State var tambnailImage: String
    @State var selectedVideo: String
    @State var videoTitle: String
    @State var videoDescription: String
    var completelessions: [lession]
    @State private var isLoading = false
    @State private var playPause = true
    // var videoPlayer: AVPlayer?
    @State private var videoPlayer = AVPlayer()
    @State private var orientation = UIDeviceOrientation.unknown
    @EnvironmentObject var downloadManager: DownloadManager
    @StateObject var network = ApiManager()
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    func trackPlay() {
        
        isLoading = true
        print("trackPlay")
    }
    func offlineVideo() {

        isLoading = true
      
        
    }
    func nextLesson() {
        videoPlayer.pause()
        videoPlayer.seek(to: .zero)
        isLoading = false
        loadURL()
        //videoPlayer.cancelPendingPrerolls()
        let videoTitels = completelessions.map(\.name)
        let index = videoTitels.firstIndex(of: videoTitle)!
        print("Lessons: \(index)")
        if videoTitels.count > index + 1{
            videoTitle = completelessions[index + 1].name
            selectedVideo = completelessions[index + 1].video_url
            tambnailImage = completelessions[index + 1].thumbnail
            videoDescription = completelessions[index + 1].description
        }else{
            videoTitle = completelessions[0].name
            selectedVideo = completelessions[0].video_url
            tambnailImage = completelessions[0].thumbnail
            videoDescription = completelessions[0].description
        }
        
    }
    func loadURL(){
        videoPlayer = AVPlayer(url: URL(string: selectedVideo)!)
    }
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color.black
                    .ignoresSafeArea()
                Group {
                    if orientation.isPortrait {
                        VStack(alignment: .center, spacing: 0) {
                            ZStack{
                                //DownloadButton()
                                Spacer()
                                if isLoading{
                                    VideoPlayer(player: videoPlayer)
                                        .frame(width: 380, height: 190)
                                        .onAppear {
                                            loadURL()
                                            if networkMonitor.isConnected{
                                                videoPlayer.play()
                                            }else{
                                               // downloadManager.urlString = selectedVideo
                                                let playerItem = downloadManager.getVideoFileAsset()
                                                videoPlayer = AVPlayer(playerItem: playerItem)
                                                videoPlayer.play()
                                            }
                                            
                                        }
                                        .onDisappear(){
                                            videoPlayer.pause()
                                        }
                                    
                                }else{
                                    AsyncImage(url: URL(string: tambnailImage)){ image in image.resizable() }                        placeholder: { Color.red } .frame(width: 380, height: 190)
                                }
                                if !isLoading{
                                   // if network.connected{
                                    
                                        Button(action: trackPlay) {
                                            Image(systemName: "play.fill")
                                                .resizable()
                                                .foregroundColor(Color.white)
                                                .scaledToFit()
                                                .frame(height:45)
                                                .shadow(radius: 5)
                                            
                                        }
                                        

                                }
                            }
                            Text(videoTitle)
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.white)
                            Text(videoDescription)
                               // .frame(width: 380, height: 190)
                                .font(.footnote)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.leading)
                            Button(action: nextLesson) {
                                 Text("Next lesson >")
                                    .frame(minWidth: 0, maxWidth: 380, alignment: .trailing)
                                     .font(.system(size: 18))
                                     .foregroundColor(.blue)
                                     .fontWeight(.bold)
                                     .padding()
                                     //.foregroundColor(.white)
//                                     .overlay(
//                                         RoundedRectangle(cornerRadius: 20)
//                                             .stroke(Color.white, lineWidth: 1)
//                                 )
                                
                                
                                
                             }
                        } //: VSTACK
                    } else if orientation.isLandscape {
                        ZStack{
                            if isLoading{
                                VideoPlayer(player: videoPlayer)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .onAppear {
                                        loadURL()
                                        //videoPlayer = AVPlayer(url: URL(string: selectedVideo)!)
                                        if networkMonitor.isConnected {
                                            videoPlayer.play()
                                        }else{
                                            downloadManager.urlString = selectedVideo
                                            let playerItem = downloadManager.getVideoFileAsset()
                                            videoPlayer = AVPlayer(playerItem: playerItem)
                                            videoPlayer.play()
                                        }
                                        
                                    }
                                    .onDisappear(){
                                        videoPlayer.pause()
                                    }
                                
                            }else{
                                AsyncImage(url: URL(string: tambnailImage)){ image in image.resizable() }                        placeholder: { Color.red } .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                            }
                            if !isLoading{
                                Button(action: trackPlay) {
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .foregroundColor(Color.white)
                                        .scaledToFit()
                                        .frame(height:45)
                                        .shadow(radius: 5)
                                    
                                }
                            }
                            
                        }
                        //Text("Landscape")
                    } else if orientation.isFlat {
                        Text("Flat")
                    } else {
                        VStack(alignment: .center, spacing: 0) {
                            ZStack{
                                if isLoading{
                                    VideoPlayer(player: videoPlayer)
                                        .frame(width: 380, height: 190)
                                        .onAppear {
                                            loadURL()
                                            //videoPlayer = AVPlayer(url: URL(string: selectedVideo)!)
                                            if networkMonitor.isConnected {
                                                videoPlayer.play()
                                            }else{
                                                downloadManager.urlString = selectedVideo
                                                let playerItem = downloadManager.getVideoFileAsset()
                                                videoPlayer = AVPlayer(playerItem: playerItem)
                                                videoPlayer.play()
                                            }
                                            
                                        }
                                        .onDisappear(){
                                            videoPlayer.pause()
                                        }
                                    
                                }else{
                                    AsyncImage(url: URL(string: tambnailImage)){ image in image.resizable() }                        placeholder: { Color.red } .frame(width: 380, height: 190)
                                }
                                if !isLoading{
                                    Button(action: trackPlay) {
                                        Image(systemName: "play.fill")
                                            .resizable()
                                            .foregroundColor(Color.white)
                                            .scaledToFit()
                                            .frame(height:45)
                                            .shadow(radius: 5)
                                        
                                    }
                                }
                                
                            }
                            Text(videoTitle)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 10)
                            Text(videoDescription)
                                .font(.footnote)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.leading)
                            Button(action: nextLesson) {
                                 Text("Next lesson >")
                                    .frame(minWidth: 0, maxWidth: 380, alignment: .trailing)
                                     .font(.system(size: 18))
                                     .foregroundColor(.blue)
                                     .fontWeight(.bold)
                                     
                                     .padding()
                                     //.foregroundColor(.white)
//                                     .overlay(
//                                         RoundedRectangle(cornerRadius: 20)
//                                             .stroke(Color.white, lineWidth: 1)
//                                 )
                                
                                
                                
                             }
                        } //: VSTACK
                        //  Text("Unknown")
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
                
                .overlay(
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding(.top,6)
                        .padding(.horizontal,8)
                    , alignment: .topLeading
                )
                .accentColor(.accentColor)
                // .navigationTitle(videoTitle)
                //  .navigationBarTitleDisplayMode(.inline)
                
                
            }
            
        }.navigationBarItems(trailing: NavigationLink(destination: DownloadButton( urlStr: selectedVideo))  {
                                    Image(systemName: downloadManager.isDownloaded ? "arrow.down.circle.fill" : "arrow.down.circle")
            

                                    }
                                    )
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            VideoPlayerView(tambnailImage: "", selectedVideo: "", videoTitle: "", videoDescription: "", completelessions: [])
        }
    }
}
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
 
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
