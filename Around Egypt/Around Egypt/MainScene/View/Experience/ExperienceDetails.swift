//
//  ExperienceDetails.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import SwiftUI

struct ExperienceDetails: View {
    let experienceViewModel: ExperienceViewModel
    let experience: Experience
    
    var body: some View {
//        ScrollView {
            VStack {
                ZStack {
                    Image("Camel")
                        .resizable()
                        .frame(width: nil, height: 300)
                        .cornerRadius(10, corners: [.topLeft, .topRight])
                        .overlay(
                            HStack {
                                Image(systemName: "eye.fill")
                                    .foregroundStyle(.white)
                                Text("156" + " views")
                                    .foregroundStyle(.white)
                                Spacer()
                                Image(systemName: "photo.on.rectangle")
                                    .foregroundStyle(.white)
                            }
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
                Group {
                    HStack {
                        Text("Abu Simbel Temples")
                            .bold()
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.red)
                        Image(systemName: "heart")
                            .foregroundStyle(.red)
                        Text("45")
                    }
                    HStack {
                        Text("Aswan, Egypt.")
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
                    Text("The Abu Simbel temples are two massive rock temples at Abu Simbel, a village in Nubia, southern Egypt, near the border with Sudan.They are situated on the western bank of Lake Nasser, about 230 km southwest of Aswan (about 300 km by road). The twin temples were originally carved out of the mountainside in the 13th century BC, during the 19th dynasty reign of the Pharaoh Ramesses Il. They serve as a lasting monument to the king and his queen Nefertari, and commemorate his victory at the Battle of Kadesh. Their huge external rock relief figures have become iconic.")
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 15)
                Spacer()
                
            }
            .background(.white)
        }
//    }
}

//#Preview {
//    ExperienceDetails()
//}
