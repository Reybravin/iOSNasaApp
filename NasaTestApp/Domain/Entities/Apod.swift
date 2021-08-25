//
//  Apod.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.08.2021.
//

struct Apod : Decodable {
    
    let copyright : String
    let date : String
    let explanation : String
    let mediaType : String
    let serviceVersion : String
    let thumbnailUrl : String? // Ignored of not a video
    let title : String
    let url : String
    
    enum CodingKeys : String, CodingKey {
        case copyright, date, explanation, title, url
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case thumbnailUrl = "thumbnail_url"
    }
    
}


//MARK: SAMPLE

/*
 {
     "copyright": "James O'DonoghueJAXARami MandowSpace AustraliaJames O'Donoghue",
     "date": "2021-08-25",
     "explanation": "Does a ball drop faster on Earth, Jupiter, or Uranus?  The featured animation shows a ball dropping from one kilometer high toward the surfaces of famous solar system bodies, assuming no air resistance.  The force of gravity depends on the mass of the attracting object, with higher masses pulling down with greater forces. But gravitational force also depends on distance from the center of gravity, with shorter distances causing the ball to drop faster.  Combining both mass and distance, it might be surprising to see that Uranus pulls the ball down slightly slower than Earth, despite containing over 14 times more mass. This happens because Uranus has a much lower density, which puts its cloud tops further away from its center of mass.  Although the falling ball always speeds up, if you were on the ball you would not feel this acceleration because you would be in free-fall. Of the three planets mentioned, the video demonstrates a ball drops even faster on Jupiter than either Earth and Uranus.",
     "media_type": "video",
     "service_version": "v1",
     "thumbnail_url": "https://img.youtube.com/vi/uHhQrplIm8g/0.jpg",
     "title": "Solar System Ball Drop",
     "url": "https://www.youtube.com/embed/uHhQrplIm8g?rel=0"
 }
 */