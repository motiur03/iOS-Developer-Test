//
//  ContentView.swift
//  iOS Developer Test
//
//  Created by Motiur Rahaman on 2023-01-16.
//

import SwiftUI
import UIKit
struct CacheData {
    let image: UIImage
    let name: String
}

struct ContentView: View {
    @State public var lessions: [lession] = []
    @State private var cacheData: [CacheData] = []
    @State private var images: [UIImage] = []
   // var imageCache = ImageCache.getImageCache()
    @State private var key: String = ""
    
    
    let apiManager = ApiManager()
    func getLessionDetail(){
        Task {
            do {
                let response = try await ApiManager.shared.generateLession()
                lessions = response.lessons
                
                                
                for url in lessions{
                    let imageUrl = URL(string: url.thumbnail)
                    let (data, _) = try await URLSession.shared.data(from: imageUrl!)
                    
                    let image = UIImage(data: data)
                    cacheData.append(CacheData(image: image!, name: url.name))
                    self.images.append(image!)
                    key = url.name

                    
                    
                }
             
                
                print("urls \(lessions)")
                
            } catch {
           
                print(error)
           
                
            }
        }
        
        
    }
    
    var body: some View {

            NavigationView {
                
                ZStack{

                if !(lessions .isEmpty){
                    
                    List(lessions) { item in
                        
                        NavigationLink(destination:VideoPlayerView(tambnailImage: item.thumbnail, selectedVideo: item.video_url, videoTitle: item.name, videoDescription: item.description, completelessions: lessions)) {
                            
                            HStack(spacing:10){
                                
                                AsyncImage(url: URL(string: item.thumbnail)){ image in image.resizable() }                        placeholder: {  } .frame(width: 100, height: 50)
                                
                                //Image(uiImage: images[0])
                                //VideoListCellView(video: item)
                                //item.video_url
                                    
                                Text(item.name)
                                    .font(.footnote)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                            }//.background(Color.black)
                        }.navigationBarTitle(Text("Lessons"))
                        .listRowBackground(Color.black)
                        
                        
                    }//.listRowBackground(Color.black)
                   
                    
                }
                    
                
            } .onAppear(perform: getLessionDetail)
                    .listStyle(InsetListStyle())
                    .background(Color.black)
                    .navigationTitle("Lessons")
                
                    //.navigationBarTitleDisplayMode(.inline)
            
            
            } .background(Color.black)
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() .previewLayout(.sizeThatFits)
            .padding()
        
    }
}
