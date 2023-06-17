//
//  WhisperManager.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 4/25/23.
//

import UIKit
import Alamofire

class WhisperManager {
    
    func transcribeAudio(audioUrl: URL, completion: @escaping (String?) -> Void) {
        let openAIUrl = "https://api.openai.com/v1/audio/transcriptions"
        let apiKey = "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"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioUrl, withName: "file")
            multipartFormData.append("whisper-1".data(using: .utf8)!, withName: "model")
        }, to: openAIUrl, headers: headers)
        .responseDecodable(of: WhisperResponse.self) { response in
            switch response.result {
            case .success(let whisperResponse):
                if let text = whisperResponse.text {
                    print(text)
                    completion(text)
                } else {
                    print("No text found in response")
                    completion(nil)
                }
            case .failure(let error):
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }
    }
}

struct WhisperResponse: Decodable {
    let text: String?
}
