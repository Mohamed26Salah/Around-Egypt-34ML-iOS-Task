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
    @State var isLiked: Bool = false
    
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
                                .applyLabelStyle(style: .BodyLargeSemiBold, color: .white)
                            Spacer()
                            Image(systemName: "photo.on.rectangle")
                                .foregroundStyle(.white)
                                .padding(.horizontal,10)
                        }
                            .frame(width: width)
                            .padding(.all), alignment: .bottom
                    )
                
                Button(action: {
                }) {
                    Text("Explore Now")
                        .applyLabelStyle(style: .BodyLargeSemiBold, color: .orangeHue)
                        .padding()
                        .frame(width: nil, height: 50)
                        .background(.white)
                        .cornerRadius(8)
                }
                
            }
            .frame(width: width)
            Group {
                HStack {
                    Text(experience.title)
                        .applyLabelStyle(style: .BodyLargeSemiBold, color: .black)
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.orangeHue)
                    }
                    Button(action: {
                        withAnimation {
                            isLiked = true
                        }
                        LocalDataManager.shared().likeExperience(experienceID: experience.id)
                        if let updateLikeCountClosure = experienceViewModel.updateLikeCount {
                            updateLikeCountClosure()
                        }
                        
                    }, label: {
                        Image(systemName: isLiked ? "heart.fill" : "heart" )
                            .foregroundStyle(.orangeHue)
                    })
                    .disabled(isLiked)
                    Text(String(LocalDataManager.shared().getExperienceByID(id: experience.id)?.likesNo ?? experience.likesNo))
                        .applyLabelStyle(style: .BodyLargeSemiBold, color: .black)
                }
                HStack {
                    Text(experience.address)
                        .applyLabelStyle(style: .BodyLargeRegular, color: .black)
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
                    .applyLabelStyle(style: .BodyLargeRegular, color: .black)
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 15)
            Spacer()
            
        }
        .background(.white)
        .getWidth($width)
        .onAppear {
            isLiked = LocalDataManager.shared().isExperienceLiked(experienceID: experience.id)
//            for family in UIFont.familyNames {
//                print("Family: \(family)")
//                for name in UIFont.fontNames(forFamilyName: family) {
//                    print("      - \(name)")
//                }
//            }
        }
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

//
//#Preview {
//    ExperienceDetails(experience: Experience(id: "0", title: "Alexandria", coverPhoto: "", description: "AlexandriaAlexandriaAlexandriaAlexandria", viewsNo: 23123, likesNo: 213, address: "Mo Salah", recommended: 1))
//}
