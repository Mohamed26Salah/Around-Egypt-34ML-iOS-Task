//
//  ExperienceDetails.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExperienceDetails: View {
    @State var width: CGFloat = .zero
    let experienceViewModel: ExperienceViewModel
    let experience: Experience
    
    var body: some View {
        //        ScrollView {
        VStack {
            ZStack {
                getImage()
                    .overlay(
                        HStack {
                            Image(systemName: "eye.fill")
                                .foregroundStyle(.white)
                                .padding(.leading,10)
                            Text(String(experience.viewsNo) + " views")
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "photo.on.rectangle")
                                .foregroundStyle(.white)
                                .padding(.horizontal,10)
                        }
                            .frame(width: width)
                            .padding(.all), alignment: .bottom
                    )
                
                Button(action: {}) {
                    Text("Explore Now")
                        .padding()
                        .frame(width: nil, height: 50)
                        .background(.white)
                        .cornerRadius(8)
                        .foregroundColor(.red)
                }
                
            }
            .frame(width: width)
            Group {
                HStack {
                    Text(experience.title)
                        .bold()
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.red)
                    Image(systemName: "heart")
                        .foregroundStyle(.red)
                    Text(String(experience.likesNo))
                }
                HStack {
                    Text(experience.address)
                        .fontWeight(.light)
                    Spacer()
                }
                Divider()
                    .padding()
                HStack {
                    Text("Description")
                        .bold()
                        .font(.title2)
                    Spacer()
                }
                Text(experience.description)
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 15)
            Spacer()
            
        }
        .background(.white)
        .getWidth($width)
    }
    @ViewBuilder
    private func getImage() -> some View {
        if experienceViewModel.isThierAnError.value {
            if let imageD = LocalDataManager.shared().getCachedImageDataFromRealm(withID: experience.id) {
                let uiImage = UIImage(data: imageD)
                Image(uiImage: uiImage!)
                    .resizable()
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width: nil, height: 300)
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            }
        } else {
            WebImage(url: URL(string: experience.coverPhoto))
                .resizable()
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: nil, height: 300)
                .cornerRadius(10, corners: [.topLeft, .topRight])
        }
    }
    //    }
}


//#Preview {
//    ExperienceDetails()
//}
